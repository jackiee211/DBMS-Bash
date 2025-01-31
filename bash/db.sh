#!/bin/bash

if [[ ! -d "$PWD/.db" ]]; then
    mkdir .db
fi

echo "================================== DB Management System ========================================"
echo "================================== ==================== ========================================"
echo "============================ Please Select One OF The Choices =================================="
echo "================================== ==================== ========================================"
echo "================================== ==================== ========================================"
echo "==================================== 1-Create Database  ========================================"
echo "==================================== 2-List  Databases  ========================================"
echo "==================================== 3-Connect Database ========================================"
echo "==================================== 4-Delete Database  ========================================"
echo "==================================== 5-Exit             ========================================"

while [[ true ]]; do

    
    echo "Choose an option: "
    read -p  "" choice


        if [[ $choice -eq 1 ]]; then

            read -p "Please Enter The Name Of The Data Base You Want To Create : " database
            if [[ ! "$database" =~ ^[a-zA-Z0-9]+$ ]]; then
                echo "Please choose a name containing only alphabetic and numeric characters are allowed"
            else    
                if [[ -d ".db/$database" ]]; then
                    echo "Sorry , a database with this name already exists - Try choosing another name"
                else
                    mkdir ".db/$database"
                    echo "database "$database" created successfully"    
                fi
            fi    
            
        elif [[ $choice -eq 2 ]]; then    

            echo "===================================== Available Databases =========================================="     
                ls .db/

        elif [[ $choice -eq 3 ]]; then    

            echo "===================================== Available Databases =========================================="
            ls .db      
            read -p "Please enter the name of the database you want to connect to: " name
            if [[ -d ".db/$name" ]]; then
            echo "======================= Connected To database (${name}) Successfully ============================"
                ./table.sh $name 
            else
                echo "Database doesn't exist, please make sure you entered the name correctly" 
            fi

        elif [[ $choice -eq 4 ]]; then 

            echo "========================================================="
            echo "=====              Avilable Databases               ====="
            echo "========================================================="
            ls .db          
            read -p  "Enter Database Name to Delete: " name
            if [[ -d ".db/$name" ]]; then
                read -p  "Are you sure you want to delete $name database (Y/N)" choice
                if [[ $choice == "Y" || $choice == "y" ]]; then
                    rm -r ".db/$name"
                    echo "database deleted sucessfully"
                else
                    echo "Invalid input, deletion aborted"
                fi
            else
                echo "Sorry, Looks like Database $name doesn't exist"   
            fi
                

        elif [[ $choice -eq 5 ]]; then     

            echo "Thank you!"     
            exit 0

        else

            echo "option doesnt exist"   

        fi    
done
