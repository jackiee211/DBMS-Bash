#!/bin/bash

echo "================================== ==================== ========================================"
echo "============================= connected to database : (${1}) ==================================="
echo "================================== ==================== ========================================"
echo "============================ Please Select One OF The Choices =================================="
echo "================================== ==================== ========================================"
echo "===================================== 1-Create table ==========================================="
echo "===================================== 2-List tables  ==========================================="
echo "===================================== 3-Show Data    ==========================================="
echo "===================================== 4-Delete table ==========================================="
echo "===================================== 5-Insert Row   ==========================================="
echo "===================================== 6-Delete Row   ==========================================="
echo "===================================== 7-Update Cell  ==========================================="
echo "===================================== 8-Exit         ==========================================="


while [[ true ]]; do
    echo "Select from table menu: "
    read -p  "" choice

    if [[ $choice -eq 1 ]]; then
    
        colnames=()
        coltypes=()
        read -p  "Enter table Name: " name

        if [[ ! "$name" =~ ^[a-zA-Z0-9]+$ ]]; then
            echo "Only alphabetic and numeric characters are allowed"
        else
            if [[ ! -f ".db/$1/$name" ]]; then
                touch ".db/$1/$name"
                read -p  "Enter columns count: " count
                for ((i = 0; i < $count; i++)); do
                    if [[ $i -eq 0 ]]; then
                        read -p  "Enter column $((i + 1)) Name as PK : " colname
                        colnames+=("$colname")

                        echo "1) String"
                        echo "2) Integer"

                        read -p  "choose column $((i + 1)) type: " coltype

                        if [[ $coltype -eq 1 ]]; then
                            coltypes+=("<String>")
                        elif [[ $coltype -eq 2 ]]; then
                            coltypes+=("<Integer>")   
                        else
                            echo "Invalid Input, defaulting to String" 
                            coltypes+=("<String>")
                        fi
                    else
                        read -p  "Enter column $((i + 1)) Name: " colname
                        colnames+=("$colname")

                        echo "1) String"
                        echo "2) Integer"

                        read -p  "choose column $((i + 1)) type: " coltype

                        if [[ $coltype -eq 1 ]]; then
                            coltypes+=("<String>")
                        elif [[ $coltype -eq 2 ]]; then
                            coltypes+=("<Integer>")   
                        else
                            echo "Invalid Input, defaulting to String" 
                            coltypes+=("<String>")
                        fi
                    fi
                done

                {   
                    echo "${colnames[@]}" | sed 's/ / : /g'
                    echo "${coltypes[@]}" | sed 's/ / : /g'
                } >> ".db/$1/.$name.meta"
            else
                echo "A table with this name already exists!! Please choose another name"    
            fi    
        fi

    elif [[ $choice -eq 2 ]]; then 

        echo "avilable tables"      
        ls .db/$1/

    elif [[ $choice -eq 3 ]]; then 

            echo "avilable tables:"
            ls .db/$1/         
            read -p  "Enter table Name to view: " name
            if [[ -f ".db/$1/$name" ]]; then
                echo "1) View all data"
                echo "2) view a specifc column based on its number"
                echo "3) view a specifc column based on its name"
                echo "4) view a specifc row based on its number"  --todo
                echo "5) view rows based on its values in it"  --todo

                read -p  "Please choose viewing method: " method
                if [[ $method -eq 1 ]]; then
                    awk  'NR == 1 {print $0}' ".db/$1/.$name.meta"
                    awk  '{print $0}' ".db/$1/$name"
                elif [[ $method -eq 2 ]]; then
                    colcount=$(awk -F: 'NR==1 {print NF}' ".db/$1/.$name.meta")
                    read -p  "Please enter column number (max $colcount): " colnum
                    if [[ $colnum -gt $colcount ]]; then
                        echo "error, the table you choose have "$colcount" columns, please choose a number less than or equal "$colcount""
                    else
                        awk -F':' -v col="$colnum" 'NR == 1 {print $col}' ".db/$1/.$name.meta"
                        awk -F'|' -v col="$colnum" '{print $col}'  ".db/$1/$name"
                    fi
                elif [[ $method -eq 3 ]]; then
                    
                    read -p  "Please enter column name: " colnam
                    colcount=$(awk -v colnam="$colnam" 'NR == 1 {for(i=1; i<=NF; i++) if ($i == colnam) {print i; exit}}' ".db/$1/.$name.meta")
                    if [[ $colcount -gt 0 ]]; then
                        awk -F':' -v col="$colcount" 'NR == 1 {print $col}'  ".db/$1/.$name.meta"
                        awk -F'|' -v col="$colcount" '{print $col}'  ".db/$1/$name"
                    else 
                        echo "the column name you entered was not found please make sure you entered the name correctly"
                    fi
                elif [[ $method -eq 4 ]]; then  
                    rowcount=$(awk 'END {print NR}' ".db/$1/$name")
                    read -p  "Please enter the row number you wish to view (max $rowcount): " rownum
                    if [[ "$rownum" -gt "$rowcount" ]]; then
                        echo "error, the table you choosed only have "$rowcount" rows, please choose a number less than or equal "$rowcount""
                    else
                        awk -F':' 'NR == 1 {print $0}'  ".db/$1/.$name.meta"
                        awk -F'|' -v row="$rownum" 'NR == row {print $0}'  ".db/$1/$name"
                    fi
                elif [[ $method -eq 5 ]]; then  
                    read -p  "Please enter the value to search for: " valnam
                    awk -F':' 'NR == 1 {print $0}'  ".db/$1/.$name.meta"
                    awk -F'|' -v rowval="$valnam" '($0 ~ rowval) {print $0}'  ".db/$1/$name"
                else
                    echo "option doesnt exist"
                fi    
            else
                echo "Table "$name" Doesnt exist" 
            fi

    elif [[ $choice -eq 4 ]]; then 

        echo "avilable tables:"
            ls .db/$1/         
            read -p  "Enter table Name to Delete: " name
            if [[ -f ".db/$1/$name" ]]; then
                read -p  "Are you sure you want to delete $name table (Y/N)" choice
                if [[ $choice == "Y" || $choice == "y" ]]; then
                    rm -r ".db/$1/$name"
                    rm -r ".db/$1/.$name.meta"
                    echo "table deleted sucessfully"
                else
                    echo "deletion aborted"
                fi
            else
                echo "table $name doesnt exist"   
            fi

    elif [[ $choice -eq 5 ]]; then 

        datas=()
        ls .db/$1/
        read -p  "Enter table Name: " name
        if [[ -f ".db/$1/$name" ]]; then
        
            colcount=$(awk -F: 'NR==1 {print NF}' ".db/$1/.$name.meta")
            
            for ((i = 0; i < $colcount; i++)); do
                if [[ i -eq 0 ]]; then
                    while [[ true ]]; do
                        type=$(awk -F' : ' -v i=$((i+1)) 'NR==2 {print $i}' ".db/$1/.$name.meta")

                        read -p  "Enter $(awk -F: -v i=$((i+1)) 'NR==1 {print $i}' ".db/$1/.$name.meta") Value (pk) "$type": " data1
                        if [[ $type == "<Integer>" ]]; then
                            if [[ $data1 =~ ^[0-9]+$ ]]; then
                                error=$(awk -F'|' -v data1="$data1" '$1 == data1 {print 1}' ".db/$1/$name")
                                if  [[ "$error" == 1 ]]; then
                                    echo "Value already exists and Pk values must be unique!! Please choose another value" 
                                else
                                    datas+=("$data1")
                                    break 
                                fi 
                            else
                                echo "sorry the value type of $(awk -F: -v i=$((i+1)) 'NR==1 {print $i}' ".db/$1/.$name.meta") is integer, please enter numbers only"
                            fi
                        else
                            if [[ $data1 =~ ^[a-zA-Z]+$ ]]; then
                                error=$(awk -F'|' -v data1="$data1" '$1 == data1 {print 1}' ".db/$1/$name")
                                if  [[ "$error" == 1 ]]; then
                                    echo "Value already exists and Pk values must be unique!! Please choose another value" 
                                else
                                    datas+=("$data1")
                                    break 
                                fi
                            else
                                echo "sorry the value type of $(awk -F: -v i=$((i+1)) 'NR==1 {print $i}' ".db/$1/.$name.meta") is string, please enter alphabitic letters only"   
                            fi    
                        fi    
                    done        
                else
                    while [[ true ]]; do
                        type=$(awk -F' : ' -v i=$((i+1)) 'NR==2 {print $i}' ".db/$1/.$name.meta")
                        read -p  "Enter $(awk -F: -v i=$((i+1)) 'NR==1 {print $i}' ".db/$1/.$name.meta") Value "$type": " data1
                        if [[ $type == "<Integer>" ]]; then
                            if [[ $data1 =~ ^[0-9]+$ ]]; then
                                datas+=("$data1")
                                break 
                            else
                                echo "sorry the value type of $(awk -F: -v i=$((i+1)) 'NR==1 {print $i}' ".db/$1/.$name.meta") is integer, please enter numbers only"
                            fi  
                        else
                            if [[ $data1 =~ ^[a-zA-Z]+$ ]]; then
                                datas+=("$data1")
                                break   
                            else
                                echo "sorry the value type of $(awk -F: -v i=$((i+1)) 'NR==1 {print $i}' ".db/$1/.$name.meta") is string, please enter alphabitic letters only"
                            fi
                        fi 
                    done         
                fi
            done

            echo "${datas[@]}" | tr ' ' '|'  >> ".db/$1/$name"
        else
            echo "Table "$name" Doesnt exist Please create the table first!!"
        fi

    elif [[ $choice -eq 6 ]]; then 
    
        ls .db/$1/
        read -p  "Enter the table Name to Delete Row From: " name

        if [[ -f ".db/$1/$name" ]]; then

            echo "1) Delete by Row number"
            echo "2) Delete Row by a Value in it (can delete multiple rows)"
            read -p  "Choose Deletion method: " method

            if [[ $method -eq 1 ]]; then
                rowcount=$(awk 'END {print NR}'".db/$1/$name")
                read -p "write the row number (max "$rowcount"): " rownum
                if [[ "$rownum" -gt "$rowcount"  ]]; then
                    echo "error, the table you choosed only have "$rowcount" rows, please choose a number less than or equal "$rowcount""
                else
                    awk -v rownum="$rownum" 'NR != rownum {print $0}' ".db/$1/$name" > ".db/$1/$name.tmp" && mv ".db/$1/$name.tmp" ".db/$1/$name"
                    echo "Sucessfully Deleted"
                fi    
            else
                read -p "write the value in the row/s: " rowval
                awk -v rowval="$rowval" '!($0 ~ rowval) {print $0}' ".db/$1/$name" > ".db/$1/$name.tmp" && mv ".db/$1/$name.tmp" ".db/$1/$name"
                echo "Sucessfully Deleted"
            fi
        else
          echo "Table "$name" Doesnt exist"      
        fi

    elif [[ $choice -eq 7 ]]; then 

        ls .db/$1/
        read -p  "Enter the table Name in which to modify the cell: " name

        if [[ -f ".db/$1/$name" ]]; then

            rowcount=$(awk 'END {print NR}' ".db/$1/$name")
            colcount=$(awk -F: 'NR==1 {print NF}' ".db/$1/.$name.meta")
            
            while [[ true ]]; do
                read -p  "Please enter column number (max "$colcount"): " colnum
                if [[ "$colnum" -gt "$colcount"  ]]; then
                    echo "error, the table you choose have "$colcount" columns, please choose a number less than or equal "$colcount""
                else
                    while [[ true ]]; do
                        read -p  "Please enter row number (max "$rowcount"): " rownum
                        if [[ "$rownum" -gt "$rowcount"  ]]; then
                            echo "error, the table you choosed only have "$rowcount" rows, please choose a number less than or equal "$rowcount""
                        else
                            if [[ $colnum -eq 1 ]]; then
                                while [[ true ]]; do
                                    type=$(awk -F' : ' -v i="$colnum" 'NR==2 {print $i}' ".db/$1/.$name.meta")
                                    read -p  "Please enter the new value ("$type"): " value
                                    if [[ $type == "<Integer>" ]]; then
                                        if [[ $value =~ ^[0-9]+$ ]]; then
                                            error=$(awk -F'|' -v value="$value" '$1 == value {print 1}' ".db/$1/$name")
                                            if [[ $error -eq 1 ]]; then
                                                echo "The enterd PK value already exists please chose another value"
                                            else
                                                awk -F'|' -v row="$rownum" -v col="$colnum" -v val="$value" 'NR == row {$col = val} {print $0}' OFS='|' ".db/$1/$name" > ".db/$1/$name.tmp" && mv ".db/$1/$name.tmp" ".db/$1/$name"
                                                break
                                            fi
                                        else
                                            echo "sorry the value type of $(awk -F: -v i="$colnum" 'NR==1 {print $i}' ".db/$1/.$name.meta") is integer, please enter numbers only"
                                        fi    
                                    else
                                        if [[ $data1 =~ ^[a-zA-Z]+$ ]]; then  
                                            error=$(awk -F'|' -v value="$value" '$1 == value {print 1}' ".db/$1/$name")
                                            if [[ $error -eq 1 ]]; then
                                                echo "The enterd PK value already exists please chose another value"
                                            else
                                                awk -F'|' -v row="$rownum" -v col="$colnum" -v val="$value" 'NR == row {$col = val} {print $0}' OFS='|' ".db/$1/$name" > ".db/$1/$name.tmp" && mv ".db/$1/$name.tmp" ".db/$1/$name"
                                                break
                                            fi
                                        else
                                            echo "sorry the value type of $(awk -F: -v i="$colnum" 'NR==1 {print $i}' ".db/$1/.$name.meta") is string, please enter alphabitic letters only"   
                                        fi    
                                    fi
                                done
                            else
                                while [[ true ]]; do
                                    type=$(awk -F' : ' -v i="$colnum" 'NR==2 {print $i}' ".db/$1/.$name.meta")
                                    read -p  "Please enter the new value ("$type"): " value
                                    if [[ $type == "<Integer>" ]]; then
                                        if [[ $value =~ ^[0-9]+$ ]]; then
                                            awk -F'|' -v row="$rownum" -v col="$colnum" -v val="$value" 'NR == row {$col = val} {print $0}' OFS='|' ".db/$1/$name" > ".db/$1/$name.tmp" && mv ".db/$1/$name.tmp" ".db/$1/$name"
                                            break 
                                        else
                                            echo "sorry the value type of $(awk -F: -v i="$colnum" 'NR==1 {print $i}' ".db/$1/.$name.meta") is integer, please enter numbers only"
                                        fi
                                    else
                                        if [[ $value =~ ^[a-zA-Z]+$ ]]; then  
                                            awk -F'|' -v row="$rownum" -v col="$colnum" -v val="$value" 'NR == row {$col = val} {print $0}' OFS='|' ".db/$1/$name" > ".db/$1/$name.tmp" && mv ".db/$1/$name.tmp" ".db/$1/$name"
                                            break 
                                        else
                                            echo "sorry the value type of $(awk -F: -v i="$colnum" 'NR==1 {print $i}' ".db/$1/.$name.meta") is string, please enter alphabitic letters only"
                                        fi
                                    fi
                                done   
                            fi
                        break    
                        fi
                    done
                break           
                fi
            done
            
                
        else
            echo "table doesnot exist!!"
        fi    

    elif [[ $choice -eq 8 ]]; then 

        echo "going back to Database script"
        exit 0 
    else
        echo "option doesnt exist"     
    fi    
done
