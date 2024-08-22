# Title: Final Assessment - PowerShell Script: Service Desk Menu
# Name: Nicolas Blouin
# Student ID: 200410446
# Course Code: COMP2138
# Date: 2024-04-17
# Description: The purpose of this script is to display a service desk menu to the screen. The user can then
# input a number listed on the menu to select the task they want to perform. When the user selects a number
# the corresponding function in my script will run. Within these functions are the ability to create a new
# Active Directory user, reset a user's Password, reset a user's department, reset a user's phone number,
# add a new security group, update group membership, create a new folder, create a new shared folder,
# add new permissions to a folder, view permissions to a folder, display server information,
# and display server resource information. Once a task is complete, I also give the user
# the option to repeat what task they just performed or return to the menu.

# I import The modules I need for my script

Import-Module ActiveDirectory
Import-Module NTFSSecurity

# I create a function called showMenu, this function displays a menu to the screen
# then based on the option selected through input, I call the function according to the
# menu option to perform specific tasks
function showMenu {

    # I clear the screen before displaying the menu options

    Clear-Host

    # I write all the options in a menu format using a series of Write-Host

    Write-Host "======Service Desk Menu======" -ForegroundColor Green
    Write-Host "1. Add New User to Active Directory"
    Write-Host "2. Reset User's Password"
    Write-Host "3. Change User's Department"
    Write-Host "4. Change User's Phone Number"
    Write-Host "5. Add New Security Group"
    Write-Host "6. Update Group Membership"
    Write-Host "7. Create New Folder"
    Write-Host "8. Create a New Shared Folder"
    Write-Host "9. Add/Update Permissions to a Folder"
    Write-Host "10. View Existing Permissions on a Folder"
    Write-Host "11. Display Server Information"
    Write-Host "12. Display Server Resource Utilization"
    Write-Host "13. Exit"

    # I take input for an option selection and store the value into the variable named $userSelection
    
    $userSelection = Read-Host "Enter an Option Number (ex. 1)"

    # Using a series of if and else if statements, I check if the $userSelection variable is equal
    # to any of the menu options numbers 1 through 13. When the input given is equal to a number on my menu being any of the
    # numbers 1 through 13, then the corresponding function within the if or elseif statement is called and ran to perform the listed task.

    if ($userSelection -eq "1") {

        addNewUser
    
    }
    
    elseif ($userSelection -eq "2") {

        resetUsersPassword

    }
    
    elseif ($userSelection -eq "3") {
    
        changeUserDepartment
    
    }

    elseif ($userSelection -eq "4") {

    
        changeUserPhoneNumber
    
    }

    elseif ($userSelection -eq "5") {

        newSecurityGroup
    
    }

    elseif ($userSelection -eq "6") {

        securityGroupMembership
    
    }

    elseif ($userSelection -eq "7") {

        createNewFolder
    
    }

    elseif ($userSelection -eq "8") {

        createNewShare
    
    }

    elseif ($userSelection -eq "9") {

        addFolderPermissions
    
    }

    elseif ($userSelection -eq "10") {

        viewFolderPermissions
    
    }

    elseif ($userSelection -eq "11") {

        displayServerInformation
    
    }

    elseif ($userSelection -eq "12") {

        displayServerResourceInformation
    
    }

    elseif ($userSelection -eq "13") {

        # I use exit to terminate the script when the user inputs a 13

        exit

    }

    # When none of the previous if and elseif statements aren't true this else code block is ran
    
    else {

        #Any other input that isn't in the menu will recall the showMenu Function
        showMenu
    
    }

}

# I created a function named addNewUser to perform the creation of a new active directory user
# I take input for the information needed using Read-Hosts and store the information into variables
# Then using New-ADUser, I can create a new active directory user with all the information given
function addNewUser {
    
    # I clear the screen using Clear-Host before displaying the task being ran
    
    Clear-Host
    
    # I display text to display the current task being performed
    
    Write-Host "======User Account Creation======" -ForegroundColor Green

    # Using a try catch, if any errors occur then the catch block below will display them

    try {
        
        # I take input for the information needed using Read-Hosts and store the information into variables
        # Then using New-ADUser, I can create a new active directory user with all the information given. 
    
        $userFirstName = Read-Host "Enter First Name"
    
        $userLastName = Read-Host "Enter Last Name"
    
        $userAccountName = "$userFirstName.$userLastName"
    
        $userPassword = Read-Host -AsSecureString "Enter a Password"
    
        $userName = Read-Host "Enter Unique Username"
    
        $userEmail = Read-Host "Enter Personal Email Address"
    
        $userPhoneNumber = Read-Host "Enter Phone Number"
    
        $userDepartment = Read-Host "Department Name (Ex. IT, Operations, Managers, etc)"

        # I create a variable to store the organizational unit path based on the Department name
        # inputted by the user
    
        $ouPath = "OU=$userDepartment,DC=adatum,DC=com"

        # I use New-ADUser to create a new active directory user with all the values
        # stored in my variables
    
        New-ADUser `
        -Name "$($userFirstName) $($userLastName)" `
        -GivenName $userFirstName `
        -Surname $userLastName `
        -SamAccountName $userName `
        -UserPrincipalName "$userAccountName@adatum.com" `
        -AccountPassword $userPassword `
        -EmailAddress $userEmail `
        -OfficePhone $userPhoneNumber `
        -Department $userDepartment `
        -Path $ouPath `
        -ChangePasswordAtLogon $true `
        -Enabled $true

        # I am checking if the new active directory user exists, if so run this if statement code
    
        if (Get-ADUser -Filter "SamAccountName -eq '$($userName)'") {
    
            # I output some text to the terminal to display that the user account created successfully
    
            Write-Host "User Account $($userName) was created Successfully within $($userDepartment)!" -ForegroundColor Green
    
        }

    }

    #when an error occurs in the above try block then this catch code block will execute to display errors

    catch {

        #I print a message to the screen saying that the

        Write-Host "Error Creating User $($userName). Make Sure to Fill All Values $($_.Exception.Message)" -ForegroundColor Red


    }

    # I add some text to the screen to ask the user if they want to make another user

    Write-Host "Would You Like to Add Another User?" -ForegroundColor Green

    # I take user input using Read-Host and store it the value into $addUserMenuChoice variable
    
    $addUserMenuChoice = Read-Host "(Y/N)?"

    # When the $addUserMenuChoice variable value is equal to a Y or y from the user input, then this if statment code block runs
    
    if ($addUserMenuChoice -eq "Y" -or $addUserMenuChoice -eq "y") {

        #call and run the addNewUser function again
    
        addNewUser
    
    }

    # when the user input is not a Y or y, then this else block runs
    
    else {

        # call and run the showMenu function to go back to the menu
    
        showMenu
    
    }

}

# I made a function named resetUsersPassword. The purpose of the function is to
# ask for input of the user account using the SAM Account Name
# Then set the password to be Changed upon Logon for the inputted User
function resetUsersPassword {
    
    # I clear the screen and displaying text for the current task
    
    Clear-Host
    
    Write-Host "======User Account Password Reset======" -ForegroundColor Green
    
    # Using a try catch, if any errors occur then the catch block below will display them

    try {

        #taking input asking for the User Name and storing into $userName variable

        $userName = Read-Host "Enter User Name (SAM Account Name)"

        # Using the $userName variable value from the Read-Host, I am setting the user to need to change their password at logon

        Set-ADUser -Identity $userName -ChangePasswordAtLogon $true

        # I write a success message
    
        Write-Host "Password Reset for User $($userName) Success. The User Will be Notified to Change Password at Next Logon." -ForegroundColor Green

        Write-Host ""

    }

    # if any errors occured in my try block above, then I display the error and show an error message with a recommendation

    catch {

        Write-Host "Error Resetting Password for User $($userName). Double Check If The User Exists" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red

    }

    # I ask the user if they want to reset another account's password

    Write-Host "Would You Like to Reset Another User's Password?" -ForegroundColor Green

    # I take user input using Read-Host and store it the value into $userResetPasswordChoice variable

    $userResetPasswordChoice = Read-Host "(Y/N)?"
    
    # When the $userResetPasswordChoice variable value is equal to a Y or y from the user input, then this if statment code block runs

    if ($userResetPasswordChoice -eq "Y" -or $userResetPasswordChoice -eq "y") {

        # I call and run the resetUsersPassword function again

        resetUsersPassword

    }

    # when the user input is not a Y or y, then this else block runs

    else {

        # I call and run the showMenu function to return to the menu

        showMenu

    }
    
}

# I created a funtion named changeUserDepartment. The purpose of this function is to
# take input for the user account that needs to be changed and then the department name
# Using these values I set the given user's department to the given department
function changeUserDepartment {

    # I clear the screen before the menu task is shown

    Clear-Host

    # I use a try catch block to handle errors

    try {

        #I display text for the current task being ran

        Write-Host "======Change User Department======" -ForegroundColor Green

        # I take user input using a series of Read-Hosts and then store the values into variables

        $userName = Read-Host "Enter User Name (SAM Account Name)"
    
        $newDepartment = Read-Host "Enter New Department (Ex. IT, Operations, Managers, etc)"

        # I get the user account identity and store the value into a variable named $userAccountName

        $userAccountName = Get-ADUser -Identity $userName

        #I set the account's department property based on the $newDepartment variable value

        Set-ADUser -Identity $userAccountName -Department $newDepartment

        #I make a variable to store an organizational unit path with the $newDepartment variable value

        $updatedOU = "OU=$newDepartment,DC=adatum,DC=com"

        # I move the user account into the organizational unit

        Move-ADObject -Identity $userAccountName.DistinguishedName -TargetPath $updatedOU

        # I write a success message to display the changes as well as show the changed user Information

        Write-Host "User Account $($userName) Department Was Changed To $($newDepartment) And Moved To $($updatedOU) Successfully!" -ForegroundColor Green

        Write-Host "New Updated User Information" -ForegroundColor Green

        Get-ADUser -Filter "SamAccountName -eq '$($userName)'"

    }

    # if any errors occured in by try block, then this catch block executes. I display the error that occured with a suggestion for next time this function is ran

    catch {

        Write-Host "Error Changing Department for User $($userName)." -ForegroundColor Red
        Write-Host "Make Sure You Entered A Valid User And Department Name (Ex. IT, Operations, Managers, etc)." -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red

    }

    # I display some text to ask if the user wants to change another user's department

    Write-Host "Would You Like to Change Another User's Department?" -ForegroundColor Green
    
    # I take user input using Read-Host and store it the value into $userDepartmentMenuChoice variable

    $userDepartmentMenuChoice = Read-Host "(Y/N)?"
    
    # When the $userDepartmentMenuChoice variable value is equal to a Y or y from the user input, the if statment code block runs

    if ($userDepartmentMenuChoice -eq "Y" -or $userDepartmentMenuChoice -eq "y") {

        # I call and run the changeUserDepartment function

        changeUserDepartment

    }

    # if the user didn't input a Y or y, then this else code is ran

    else {

        # I call and run the showMenu function to return to the menu again

        showMenu

    }

}

# I created a function named changeUserPhoneNumber. The point of this
# function is to take input of which account that the user wants to alter the phone number for.
# Then I take input for the new phone number. I then set the users phone number based on the
# given value
function changeUserPhoneNumber {

    # I clear the screen before showing the menu task

    Clear-Host

    # I use a try catch for error handling

    try {

        # I display text to show the current menu task

        Write-Host "======Change User Phone Number======" -ForegroundColor Green

        # I take user inputs for the account name and new phone number and store the inputted
        # values into variables

        $userName = Read-Host "Enter User Name (SAM Account Name)"
    
        $updatePhoneNumber = Read-Host "Enter New Phone Number"

        # I set the given users phone number to the new phone number given from user input
    
        Set-ADUser -Identity $userName -OfficePhone $updatePhoneNumber

        # I display a success message to show the user had their phone number changed
        # as well as the new updated properties of the user account
    
        Write-Host "User Account $($userName) Phone Number Was Changed To $($updatePhoneNumber)" -ForegroundColor Green

        Write-Host ""
    
        Write-Host "New Updated User Information:" -ForegroundColor Green
    
        Get-ADUser -Filter "SamAccountName -eq '$($userName)'" -properties telephoneNumber

    }

    # if any errors occured during the above try block, I display the error message

    catch {

        Write-Host "Error Changing Phone Number for User $($userName). $($_.Exception.Message)" -ForegroundColor Red
        
    }

    # I display a message to ask the user if they want to change another user accounts phone number

    Write-Host "Would You Like to Change Another User Account's Phone Number?" -ForegroundColor Green
    
    # I take user input using Read-Host and store it the value into $userPhoneNumberMenuChoice variable
    
    $userPhoneNumberMenuChoice = Read-Host "(Y/N)?"
    
    # When the $userPhoneNumberMenuChoice variable value is equal to a Y or y from the user input, the if statment code block runs
    
    if ($userPhoneNumberMenuChoice -eq "Y" -or $userPhoneNumberMenuChoice -eq "y") {

        # I call and run changeUserPhoneNumber function
    
        changeUserPhoneNumber
    
    }

    # when the user doesn't input a Y or y, this else is ran
    
    else {

        # I call and run the showMenuFunction
    
        showMenu
    
    }

}

# I created a function named newSecurityGroup. The task performed in this function
# is to take user input for the name of the new security group and the department it belongs.
# With the given values, I make a new security group
function newSecurityGroup {

    # I clear the screen using Clear-Host before showing the menu task being performed

    Clear-Host

    #I use a try catch to handle potential errors

    try {

        # I display a message banner to show the current task

        Write-Host "======Create Security Group======" -ForegroundColor Green

        # I am obtaining the inputs using Read-Host. I then store the inputted
        # values into appropriate variables
    
        $securityGroupName = Read-Host "Enter Security Group Name"

        $departmentName = Read-Host "Enter Security Group Department (Ex. IT, Operations, Managers, etc)."

        # I store a the organizational unit path into the variable $organizationalUnitPath.
        # I substitute the OU with the department name from user input above

        $organizationalUnitPath = "OU=$departmentName,DC=adatum,DC=com"
    
        # I create the new security group using the New-ADGroup command and specify my path using the value stored
        # in the $organizationalUnitPath variable.
    
        New-ADGroup -Name $securityGroupName -GroupScope "Global" -GroupCategory "Security" -Path $organizationalUnitPath

        # I print out a success message that the security group was created and then show the
        # new group information using Get-ADGroup
        
        Write-Host "Successfully Created Security Group $($securityGroupName) for $($departmentName) Department" -ForegroundColor Green
        
        Write-Host ""
        
        Write-Host "New Security Group Information:" -ForegroundColor Green
        
        Get-ADGroup -Filter "Name -eq '$($securityGroupName)'"

    }

    # when any errors occur during my try block then this catch will execute to display the error message
    # I give some recommendations to avoid the error when running this task again

    catch {

        Write-Host "Error Creating Security Group $($securityGroupName)" -ForegroundColor Red
        Write-Host "Double Check If You Entered A Valid Department (Ex. IT, Operations, Managers, etc)." -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        
    }

    # I ask the user if they want to create another security group
        
    Write-Host "Would You Like to Create Another Security Group?" -ForegroundColor Green

    # I take user input using Read-Host and store the value into $securityGroupMenuChoice

    $securityGroupMenuChoice = Read-Host "(Y/N)?"

    #when the user inputs a Y or y this if statement is executed
    
    if ($securityGroupMenuChoice -eq "Y" -or $securityGroupMenuChoice -eq "y") {

        # I call and run my newSecurityGroup function

        newSecurityGroup
    
    }

    # when the user doesn't input a Y or y, then this else is ran
    
    else {

        # I call and run the showMenu function
    
        showMenu
    
    }
    
}

# I created a new function named securityGroupMembership. The purpose of this function is to
# add or remove a user from a security group
function securityGroupMembership {

    # I clear the screen before showing the menu task being performed

    Clear-Host

    # I use a try catch for error handling

    try {

        #I add a message to display the task being performed
        
        Write-Host "======Update Security Group Membership======" -ForegroundColor Green

        # I take user input to obtain the security group name

        $securityGroupName = Read-Host "Enter Security Group Name"

        # I check if the security group the user inputted exists. By using a -not
        # the if statement will evaluate as true if a security group with the given name doesn't
        # exist
        
        if (-not (Get-ADGroup -Filter "Name -eq '$($securityGroupName)'")) {
            
            Write-Host "Security Group $($securityGroupName) Doesn't Exist." -ForegroundColor Red

        }

        # if the above if statment checking if the group exists isn't true then that would indicate
        # the security group provided by the user exists, so this else statement runs

        else {

            # I take user input to obtain the account to edit permissions
            # and then the action to add or remove

            $userName = Read-Host "Enter User Name (SAM Account) You Want to Add or Remove"

            $addOrRemove = Read-Host "Enter Action (Add/Remove)"

            # I convert the input for add/remove to lowercase for more efficent input validation checking

            $addOrRemove = $addOrRemove.ToLower()

            # if the user didn't input the value add or remove, I use a while -not to continously
            # ask the user to input if they give anything other than the value add or remove
            
            while (-not ($addOrRemove -eq "add" -or $addOrRemove -eq "remove")) {
    
                Write-Host "Invalid Input. Please Enter 'Add' or 'Remove' Only!" -ForegroundColor Red
                $addOrRemove = Read-Host "Enter Action (Add/Remove)"
    
            }

            # if the $addOrRemove variable value from user input value is equal to "add" then this if statement code runs
    
            if ($addOrRemove -eq "add") {

                # I add the the user account to the security group using the variable values from user input
    
                Add-ADGroupMember -Identity $securityGroupName -Members $userName
                Write-Host "User $($userName) Has Been Added to Group $($securityGroupName) Successfully" -ForegroundColor Green
    
            }

            # if the $addOrRemove variable value from user input value is equal to "remove" then this if statement code runs
    
            elseif ($addOrRemove -eq "remove") {

                # I remove the user account from the security group using the variable values from user input
    
                Remove-ADGroupMember -Identity $securityGroupName -Members $userName -Confirm:$false
                Write-Host "User $($userName) Has Been Removed From Group $($securityGroupName) Successfully" -ForegroundColor DarkYellow
    
            }
            
        }

    }

    # if any errors occured during my try block, I display an error message

    catch {

        Write-Host "Error Updating Security Group Membership $($securityGroupName). $($_.Exception.Message)" -ForegroundColor Red
        
    }

    # I write a message to the screen to ask if the user would like to update membership on another group
        
    Write-Host "Would You Like to Update Membership on Another Security Group?" -ForegroundColor Green

    # I take user input and store the value into $membershipUpdateChoice variable

    $membershipUpdateChoice = Read-Host "(Y/N)?"
    
    # When the $membershipUpdateChoice variable value is equal to a Y or y from the user input, this if statment code block runs

    if ($membershipUpdateChoice -eq "Y" -or $membershipUpdateChoice -eq "y") {

        # I call and run the securityGroupMembership function

        securityGroupMembership

    }

    # if the user didn't input a Y or y, then this else code is ran

    else {

        # I call and run the showMenu function

        showMenu

    }
    
}

# I made a function named createNewFolder. In this function
# I take user input for the folderPath to create a new
# folder on the system
function createNewFolder {

    # I clear the screen before showing the menu task being performed

    Clear-Host

    # I display text to the screen for the current task

    Write-Host "======Create New Folder======" -ForegroundColor Green

    # I ask the user to specify the path and name of the folder they want to create.
    # I take the input and store it into the $newFolderPath variable

    $newFolderPath = Read-Host "Enter the Path and Name of Your Folder (ex. C:\NewFolderName)"

    # I check to validate that the users input is in correct format using -match

    if ($newFolderPath -match "^[a-zA-Z]:\\") {

        # I use a try cach to handle errors

        try {
            
            #I am using a -not with Test-Path to check if the path to stored in the $newFolderPath variable does not
            #exist, if true, then I create a new folder with the user's inputted value

            if (-not (Test-Path $newFolderPath -PathType Container)) {

                New-Item -Path $newFolderPath -ItemType Directory -Force
                Write-Host "Created Folder Successfully: $($newFolderPath)" -ForegroundColor Green
    
            }

            # when the above if statement doesn't execute then the folder exists already, so this
            # else statement is ran displaying a message that the folder exists already
    
            else {
    
                Write-Host "Folder Already Exists At $($newFolderPath)" -ForegroundColor DarkYellow
    
            }
            
        }

        # if any errors occured in my try block, then I display the error message saying that
        # there was an error creating the new folder as well as the exception message

        catch {

            Write-Host "Error Creating New Folder At $($newFolderPath). $($_.Exception.Message)" -ForegroundColor Red
            
        }

    }

    # When the above if statment checking path format doesn't execute, this else is ran
    # displaying message that the format to the folder is incorrect

    else {

        Write-Host "Invalid Path. Ensure to Use Format 'DriveLetter:\'" -ForegroundColor Red

    }

    # I ask the user if they want to create another folder

    Write-Host ""

    Write-Host "Would You Like to Create Another Folder?" -ForegroundColor Green

    # I take user input using Read-Host and store the value into $createFolderChoice

    $createFolderChoice = Read-Host "(Y/N)?"

    # if the user inputs a Y or y, then this if statement code runs

    if ($createFolderChoice -eq "Y" -or $createFolderChoice -eq "y") {

        # I call and run the createNewFolder function

        createNewFolder

    }

    # when the user doesn't enter a Y or y, then this else is ran

    else {

        # I call and run the showMenu function

        showMenu

    }
    
}

# I made a function named createNewShare. This function will take user input
# and for a share name and then the share path. I use these values to create
# a new shared folder
function createNewShare {

    # using Clear-Host I clear the screen before showing the menu task being performed

    Clear-Host

    # I display text to show the current task being performed

    Write-Host "======Create New Share======" -ForegroundColor Green

    # I take user input for the share name and share path and store
    # these values into variables

    $shareName = Read-Host "Enter New Share Name"
    $sharePath = Read-Host "Enter the Path to Be Shared (ex. C:\SharedFolder)"

    # I validate that the user input is the correct format using
    # -match for the path to the share

    if ($sharePath -match "^[a-zA-Z]:\\") {


        #I am using a -not to test if the path to the $sharePath value does not
        #exist, if true, then I ask if the user wants to create a new folder with inputted value

        if (-not (Test-Path $sharePath -PathType Container)) {

            # I ask if the user wants to create the folder with the value they provided if it doesn't exist already

            Write-Host "Share Path $($sharePath) Does't Exist. Would You Like To Create A Folder With This Name?" -ForegroundColor Green

            # I take user input and store it into $createFolderChoice variable
            
            $createFolderChoice = Read-Host "(Y/N?)"
            
            # When the $createFolderChoice variable value is equal to a Y or y from the user input, then this if statment code block runs

            if ($createFolderChoice -eq "Y" -or $createFolderChoice -eq "y") {

                # I use a try block for handling errors

                try {

                    #I create a new folder using the $sharePath variable value from user input

                    New-Item -Path $sharePath -ItemType Directory -Force

                    Write-Host ""

                    # I display a success message if the folder is created
    
                    Write-Host "Folder Successfully Created at '$($sharePath)'" -ForegroundColor Green 
                    
                }

                # if my try block encountered any errors then this catch block will execute and display a message
                # saying there was an error. I also display the exception error

                catch {

                    Write-Host "Error Creating New Folder At $($sharePath). $($_.Exception.Message)" -ForegroundColor Red
                    
                }  

            }

            # when the user doesn't enter a Y or y, then this else is ran

            else {

                # I call and run my showMenu function

                showMenu

            }

        }

        # I use a try catch for error handling

        try {
            
            # I am checking if a share exists with the $shareName variable value.
            # if it doesn't exist I make a new share

            if (-not (Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue)) {

                # I make a new share using the variable values $shareName and $sharePath that were given from user input

                New-SmbShare -Name $shareName -Path $sharePath

                # I display a success message saying the share was created successfully

                Write-Host "Share $($shareName) Was Created Successfully" -ForegroundColor Green
    
            }
            
            # when the above if statement doesn't execute then the share name exists already, so this
            # else statement will run
    
            else {

                # I am displaying a message that the share name exists already
    
                Write-Host "Share Name $($shareName) Already Exists"
    
            }
            
        }

        # when my try block encounters an error then this catch block will run, I display an error message
        # mentioning that there was an error creating the share. I also display the exception message

        catch {

            Write-Host "Error Creating Share $($shareName) At $($sharePath). $($_.Exception.Message)" -ForegroundColor Red
            
        }

    }

    # When the above if statment checking path format isn't true, this else is ran
    # displaying message that the path format to the shared folder is incorrect

    else {

        Write-Host "Invalid Share Path. Ensure to Use Format 'DriveLetter:\SharedFolder'" -ForegroundColor Red

    }

    # I ask the user if they would like to create another share

    Write-Host ""

    Write-Host "Would You Like to Make Another Share?" -ForegroundColor Green

    # I take user input and store it into $shareChoice variable

    $shareChoice = Read-Host "(Y/N)?"

    # When the $shareChoice variable value is equal to a Y or y from the user input, then this if statment code block runs

    if ($shareChoice -eq "Y" -or $shareChoice -eq "y") {

        # I call and run my createNewShare function

        createNewShare

    }

    # when the user doesn't enter a Y or y, then this else statement will run

    else {

        # I call and run my showMenu function

        showMenu

    }

    
}

# I created a function named addFolderPermissions. The purpose of this function
# is to add permissions to a folder for a user. I take the input from the user to obtain
# folder and the user account who will have permissions added to the folder. After the inputs
# are valid I ask which permissions to be added either Read, Modify, or FullControl
function addFolderPermissions {

    # I clear the screen

    Clear-Host

    # I display text to show the current task being ran

    Write-Host "======Add/Update Folder Permissions======" -ForegroundColor Green

    # I take input from the user to obtain the folder to edit permissions on. I store the user's input into the
    # $folderPath variable

    $folderPath = Read-Host "Enter the Path And Name of The Folder You Wish to Edit Permissions (ex. C:\FolderName)"

    # I check the user's input with -match to validate if the path format is correct before proceeding

    if ($folderPath -match "^[a-zA-Z]:\\") {
        
        #I am using a -not with Test-Path to check if the path value stored in the $folderPath variable does not
        #exist, if true, this if statement will run displaying a message that the folder the user entered doesn't exist

        if (-not (Test-Path $folderPath -PathType Container)) {

            Write-Host "Folder $($folderPath) Doesn't Exist" -ForegroundColor Red
    
        }

        # if the above if statment checking if the folder exists is true then that would indicate
        # the security group provided by the user exists, so this else statement runs

        else {

            # I use a try to handle errors

            try {

                # I ask for the account name to add permissions for on a folder. I take input from
                # the user and store the inputted value into the $accountName variable

                $accountName = Read-Host "Enter The Account Name To Add/Update Permissions On The Folder"

                # I am checking if the user account inputted exists 

                if (Get-ADUser -Filter "SamAccountName -eq '$($accountName)'"){

                    # I use Get-NTFSAccess to obtain the permissions the user has on the folder
                    # and store this value into the $currentPermissions variable
    
                    $currentPermissions = Get-NTFSAccess -Path $folderPath -Account $accountName

                    # Using -match on the information stored within my $currentPermissions variable,
                    # I am checking if the the user already has FullControl on the folder, if so run the if statement
    
                    if ($currentPermissions -match "FullControl") {

                        # I make a table with Path as the $folderPath value given by the user input
                        # I set the Account value to the $accountName value from the user input
                        # Then I set the AccessRights to FullControl.
    
                        $removePermissionValues = @{
                
                            Path = $folderPath
                            Account = $accountName
                            AccessRights = "FullControl"
                    
                        }

                        # I use Remove-NTFSAccess with the @removePermissionValues table values to remove
                        # FullControl rights to avoid potential permission change conflicts  
    
                        Remove-NTFSAccess @removePermissionValues
                        
                    }

                    # I take user input for the permission level they want to give the user on the folder and store the value in the $permissionChoice variable
    
                    $permissionChoice = Read-Host "Enter A Permission Option For User $($accountName) | ( 'Read' , 'Modify' or 'FullControl' )"
    
                    # I update the inputted value from to lower case for easier input validation checking
    
                    $permissionChoice = $permissionChoice.ToLower()

                    # I use a while -not loop to continuosly ask the user to enter read, modify, or fullcontrol if they input any other
                    # value. I use this to force the user to give a valid input
    
                    while(-not ($permissionChoice -eq "read" -or $permissionChoice -eq "modify" -or $permissionChoice -eq "fullcontrol")){
    
                        Write-Host "Inavlid Input. Enter 'Read' , 'Modify' or 'FullControl' Only" -ForegroundColor Red
    
                        $permissionChoice = Read-Host "Enter A Permission Option For User $($accountName) | ( 'Read' , 'Modify' or 'FullControl' )"
                        
                        # I update the inputted value from to lower case for easier input validation checking
                        
                        $permissionChoice = $permissionChoice.ToLower()
    
    
                    }

                    # when the user inputs read this if statement runs and sets the $permissionLevel variable value to Read
            
                    if ($permissionChoice -eq "read") {
                
                        $permissionLevel = "Read"
                
                    }

                    # when the user inputs modify this elseif statement runs and sets the $permissionLevel variable value to Modify
                
                    elseif ($permissionChoice -eq "modify") {
                
                        $permissionLevel = "Modify"
                
                    }
                    
                    # when the user inputs fullcontrol this elseif statement runs and sets the $permissionLevel variable value to FullControl
                
                    elseif ($permissionChoice -eq "fullcontrol") {
                
                        $permissionLevel = "FullControl"
                
                    }

                    #I remove inheritence on the $folderPath value given by the user
    
                    $RemoveInherit = @{
                        Path = $folderPath
                        RemoveInheritedAccessRules = $True
    
                    }
                        
                    Disable-NTFSAccessInheritance @RemoveInherit

                    # I create a table for the updated user permissions to add to the folder
                    # I set the Path value using the $folderPath value given by the user input
                    # I set the Account value to the $accountName value from the user input
                
                    $permissionValues = @{
                
                        Path = $folderPath
                        Account = $accountName
                        AccessRights = $permissionLevel
                
                    }

                    # I use Add-NTFSAccess to add the permissions using the @permissionValues table values
                
                    Add-NTFSAccess @permissionValues

                    # I display a success message with saying the persmissions were updated
                    
    
                    Write-Host "User Account $($accountName) Permissions Updated Successfully!" -ForegroundColor Green
    
                    Write-Host ""
    
                    Write-Host "Folder Permission Information:" -ForegroundColor Green

                    # I use Get-NTFSAccess $folderPath to show the new permission information
    
                    Get-NTFSAccess $folderPath
            
                }

                # When the if statement above which checks if an account exists doesn't execute the
                # this else statement is ran. I display a message to show the account that the
                # user inputted doesn't exist

                else {
    
                    Write-Host "Account $($accountName) Doesn't Exist" -ForegroundColor Red
    
    
                }
                
            }

            # if any errors occured in my try block, then this catch will execute and display
            # an error message. I say that there was an error changing the permissions and then
            # also show the exception message

            catch {

                Write-Host "Error Changing Permissions. $($_.Exception.Message)" -ForegroundColor Red
                
            }
            
        }
    


    }

    # When the above if statment checking path format isn't true, that would indicate the path format was wrong this else is ran
    # displaying message that the format to the folder is incorrect

    else {

        Write-Host "Invalid Path. Ensure to Use Format 'DriveLetter:\NameOfFolder'" -ForegroundColor Red

    }

    # I display text to ask the user is they want to add permissions of a user to another folder

    Write-Host ""

    Write-Host "Would You Like to Add Permissions of A User To Another Folder?" -ForegroundColor Green

    # I take user input with Read-Host and store the value in the $addFolderPermissionChoice variable

    $addFolderPermissionChoice = Read-Host "(Y/N)?"

    # When the user types a y for the $addFolderPermissionChoice Read-Host input value this if statment code runs

    if ($addFolderPermissionChoice -eq "Y" -or $addFolderPermissionChoice -eq "y") {

        # I call and run the addFolderPermissions function

        addFolderPermissions

    }

    # if the user didn't input a Y or y, this else statment code is ran

    else {

        # I call my showMenu function to return to the menu

        showMenu

    }
    
}


# I created a function named viewFolderPermissions. This functions will take
# input from the user to view the folder permissions they have entered.
function viewFolderPermissions {

    # I clear the screen using Clear-Host

    Clear-Host

    # I display some text to make a heading for the task being ran

    Write-Host "======View Folder Permissions======" -ForegroundColor Green

    # I ask the user for the folder path. I take the user input and store it into
    # the $folderPath variable

    $folderPath = Read-Host "Enter the Path To View Permissions (ex. C:\FolderName)"

    # I check the user's input with -match to verify that the path format is correct
    # if the format is correct, this if statement will run

    if ($folderPath -match "^[a-zA-Z]:\\") {

        # I use a try catch to handle errors

        try {
            
            #I am using a -not with Test-Path to check if the path value stored in the $folderPath variable does not
            #exist, if true, this if statement will run displaying a message that the folder the user entered doesn't exist


            if (-not (Test-Path $folderPath -PathType Container)) {

                Write-Host "Folder $($folderPath) Doesn't Exist" -ForegroundColor Red
        
            }
            
            # if the above if statment checking if the folder exists doesn't execute,
            # then that would indicate the folder aldready exists, so this else statement runs
    
            else {

                # I use Get-NTFSAccess to view the permission information on the folder that was inputted by the user 
    
                Get-NTFSAccess $folderPath | Format-Table -AutoSize
                
            }
            
        }

        # if any errors occured in my try block, then this catch block will execute displaying an error
        # message saying that there was an error viewing permissions as well as the exception message

        catch {

            Write-Host "Error Viewing Permissions. $($_.Exception.Message)" -ForegroundColor Red
            
        }
    
    }

    # when the above if statement that checks path format doesn't execute, then this else
    # statement is ran displaying a message that the path format is an invalid path

    else {
        
        Write-Host "Invalid Path. Ensure to Use Format 'DriveLetter:\NameOfFolder'" -ForegroundColor Red
    
    }

    # I ask the user if they want to view permissions on another folder

    Write-Host "Would You Like to View Permissions On Another Folder?" -ForegroundColor Green

    # I take user input and store it into the $ViewFolderPermissionChoice variable

    $ViewFolderPermissionChoice = Read-Host "(Y/N)?"
    
    # When the user types a y for the $ViewFolderPermissionChoice Read-Host input value this if statment code runs

    if ($ViewFolderPermissionChoice -eq "Y" -or $ViewFolderPermissionChoice -eq "y") {

        # I call and run the viewFolderPermissions function

        viewFolderPermissions

    }

    # when the user doesn't input a Y or y, then this else code is ran

    else {

        # I call and run the showMenu function

        showMenu

    }
    
}

# I created a function named displayServerInformation
# which will gather information such as Operating System,
# Computer Name, Current User, and Server Uptime
function displayServerInformation {

    #I clear the screen before showing the Server Information text

    Clear-Host

    # I write text to show the current task being performed

    Write-Host "======Server Information======" -ForegroundColor Green
    
    # I use Get-CIMInstance -ClassName Win32_OperatingSystem with .Caption to extract just the
    # Caption property to obtain the name of the OS

    $operatingSystem = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    
    # I obtain the OS information with Get-CimInstance -ClassName Win32_OperatingSystem,
    # adding .LastBootUpTime to the end of my command lets me extract the LastBootUpTime property value
    #I then store into $lastBootTime variable

    $lastBootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime

    # I use Get-Date to obtain the current date and time and then subtract by the $lastBootTime variable to obtain the system uptime
    # then store it into the $uptime variable

    $uptime = (Get-Date) - $lastBootTime

    #I display the operating system information using the value stored in my $operatingSystem Variable

    Write-Host "Operating System:" -ForegroundColor Green
    Write-Host $operatingSystem

    # I display the computer name to the screen using the environmental variable $env:ComputerName

    Write-Host "Computer Name:" -ForegroundColor Green
    Write-Host $env:ComputerName

    # I output the current username to the screen using the environmental variable $env:Username

    Write-Host "Current User:" -ForegroundColor Green
    Write-Host $env:Username

    # I use the output information stored in my $uptime variable to output the server uptime in
    # Days, Hours, and Minutes Format

    Write-Host "Server Uptime:" -ForegroundColor Green
    
    Write-Host "$($uptime.Days) Days, $($uptime.Hours) Hours, $($uptime.Minutes) Minutes"

    # I ask the user if they want to return to the menu

    Write-Host "Would You Like To Return to Menu?" -ForegroundColor Green

    $serverInformationExit = Read-Host "(Y/N?)"

    # When the $serverInformationExit variable value is equal to a Y or y from the user input, then this if statment code block runs

    if ($serverInformationExit -eq "Y" -or $serverInformationExit -eq "y") {

        # I call and run the showMenu function

        showMenu

    }

    # when the user doesn't type a Y or y, then this else statement will run

    else {

        # I call and run my displayServerInformation function
        
        displayServerInformation

    }
    
}

# I created a function named displayServerResourceInformation. In this function
# I am obtaining, then displaying server resource information such
# as processor utilization, memory, and all disk information
function displayServerResourceInformation {

    # I clear the screen

    Clear-Host

    # I write text to the screen to show the current task

    Write-Host "======Server Resource Information======" -ForegroundColor Green
    
    # I obtained the processor information using Get-CimInstance -ClassName Win32_Processor
    # Then measured the average across CPU cores to find the total utilization.
    # then using .Average I extract the Average property.
    # I store the the Average property value into my $cpuUtilization variable

    $cpuUtilization = (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

    # I obtained the memory on the system by using Get-CIMInstance -ClassName Win32_PhysicalMemory
    # I then added .Capacity at the end to extract only the Capacity Property Value.
    # I divide the value by 1GB to convert the memory capacity to GB format

    $memoryAvailable = (Get-CIMInstance -ClassName Win32_PhysicalMemory).Capacity / 1GB

    # I display the information from my variable values in an organized format

    Write-Host "CPU Utilization:" -ForegroundColor Green

    Write-Host "$cpuUtilization%"

    Write-Host "Memory:" -ForegroundColor Green
    Write-Host "$memoryAvailable GB"

    Write-Host "Disk Information:" -ForegroundColor Green

    # I obtained the disks on the system using Get-CimInstance Win32_LogicalDisk
    # then using a ForEach-Object to loop through each disk
    
    Get-CimInstance Win32_LogicalDisk | ForEach-Object {
    
        # I display the disks to the screen
    
        Write-Host "Drive: $($_.DeviceID)"
    
        # I also display the Size and FreeSpace. I divide by 1GB to display
        # the disk space values in GB.
        # Math round function will round the disk values to 2 decimal places
    
        Write-Host "Total Size (GB): $([math]::Round($_.Size / 1GB, 2))"
        Write-Host "Free Space (GB): $([math]::Round($_.FreeSpace / 1GB, 2))"
    
    
    }

    # Write Text to ask user is they want to return to menu

    Write-Host "Would You Like To Return to Menu?" -ForegroundColor Green

    #take user input using Read-Host and store it into $resourceInformationExit variable

    $resourceInformationExit = Read-Host "(Y/N?)"

    # if the $resourceInformationExit variable value is equal to a Y or y run this if statement code

    if ($resourceInformationExit -eq "Y" -or $resourceInformationExit -eq "y") {

        # call and run the showMenu function to return to the menu

        showMenu

    }

    # when the user doesn't input a Y or y, then the displayServerResourceInformation function is called again

    else {

        # I call and run displayServerResourceInformation function

        displayServerResourceInformation

    }
    
}

#This Initial Function Call Starts My Script
#The script will continously run in the menu and functions until exited using option 13

showMenu
