# Title: Mid Term - PowerShell Script: Importing Users to Active Directory Assessment
# Nicolas Blouin
# Student ID: 200410446
# Course Code: COMP2138
# Date: 2024-02-25
# Description: The purpose of my script is to create Active Directory User Accounts from an imported csv file.
# I ask the user running the script to type in the path to their csv file. Next, my script will iterate through the csv values for each user to create accounts.
# Organizational Units and Security Groups are created along with adding each user into their respective Organizational Unit and Security Group.

# I use the this sequence of commands together to retieve the current user that ran the script and checking if they are
# an administrator or not. Using the Windows Identity with GetCurrent() pulls the current user that ran the script and the .IsInRole() filtered with "Administrator" checks
# if the user is in the administrator role. Using a -not this will reverse the logic, so if the user is not in the administrator role the
# if statement will run, and then exit my script.

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    # Print some dialogue to the screen to let the user know that they need to be an admin

    Write-Host "You Need Admin Rights To Run This Script!"

    # using exit will terminate the script

    exit

}

# I import the ActiveDirectory module to make sure
# I can use the Active Directory cmdlets in my script

Import-Module ActiveDirectory

# Add a Read-Host to ask the user to import a csv, I hen store
# the value the user inputs into the variable named csvFile

$csvFile = Read-Host "Please Enter The Path of Your CSV File"

# I then use the Import-csv command on the $csvFile variable which holds the users inputted csv file.
# This will then read all the data from the csv file, I then store it 
# into the variable named $activeDirectoryUsers

$activeDirectoryUsers = Import-csv $csvFile

# obtain the count of items in the csv file using .Count 
# and store it into a variable named totalItemCount

$totalItemCount = $activeDirectoryUsers.Count

# I create a variable named currentItemCount and assign it as 0
# I use this later for progress bar tracking.

$currentItemCount = 0

#I create a foreach loop to iterate through each user in the csv file that was provided
# and perform various actions for each user such as adding them to Organizational Units and Security Groups

foreach ($user in $activeDirectoryUsers) {

    # Increment the current count for everytime a new user is being proccessed in the for loop

    $currentItemCount++

    # I am performing a percentage conversion by taking the value of $currentItemCount
    # and dividing the $totalItemCount, then multiplying by 100 to obtain the percent
    # I then store this value into the variable named $percentageOfCompletion

    $percentageOfCompletion = ($currentItemCount / $totalItemCount) * 100

    # I display my progress bar to the screen and use the calculated values from above

    Write-Progress -Activity "Active Directory Users Are Being Created" -PercentComplete $percentageOfCompletion

    # I include my Organizational Unit Creation code within a try catch
    # so that I can catch any errors that may occur during the Organizational Unit Creation

    try {
        

        # Using Get-ADOrganizationalUnit I can add a filter to see if an OU exist matching the name of the current user's department,
        # if it doesn't exist then run this if block.
        
        if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$($user.department)'")) {
            
            # I am creating a new OU, with the department value name for the current user being processed in the for loop.
            # I also set the path of where this OU is to be created which is under the adatum domain
            
            New-ADOrganizationalUnit -Name $user.department -Path "DC=adatum,DC=com"

        }
        
    }

    # When my script errors due to the code within my try block above
    # the catch block will run and catch the error that occured

    catch {

        # If the catch block executed due to an error, I write an error message saying the Organizational Unit 
        # then I print the exception message which will show what went wrong

        Write-Host "An Error Occured While creating the Organization Unit $($user.department) $($_.Exception.Message)" -ForegroundColor Red

    }

    # I put my Security Group creation code inside a try catch to handle errors which may occur during the security
    # group creation

    try {

        # I use Get-ADGroup to obtain current groups and check if the name of the group matching the user's departments exists using a filter.
        # If the group doesn't exist this condition executes
        
        if (-not (Get-ADGroup -Filter "Name -eq '$($user.department)'")) {
            
            # Create a new Active Directory group based on the name of the department of the current user being processed in the for loop.
            # I set the type to a security group, as well as specify the path which the group is created, this being the current user's ou value from the csv.
            
            New-ADGroup -Name $user.department -GroupScope Global -GroupCategory Security -Path $user.ou

        }
    }

    # if any errors occured during my security group creation from above
    # then this catch block will run and display the issue which triggered the error

    catch {

        # I write an error message to the temrinal to inform the user running my script that the Security
        # Group Creation for the current user from the csv being processed in the loop failed.
        # I then show the exeception message to display what went wrong

        Write-Host "An Error Occured Creating the Security Group $($user.department) $($_.Exception.Message)" -ForegroundColor Red

    }
    
    # I use an if statement to check if an account already exists using the Get-ADUser command with a filter.
    # I filter if the SamAccountName is equal to the username value from the csv for the current user
    # being processed in the for loop. If true then this if statement will execute.

    if (Get-ADUser -Filter "SamAccountName -eq '$($user.username)'") {

        # I write some text to the terminal to say the account already exists I include the
        # current username variable within the output for clarity of which user is already present.

        Write-Host "User account $($user.username) already exists." -ForegroundColor DarkYellow

        # When this if statement executes that means the user already exists so I use a continue
        # to immediatley skip to the next iteration of the for loop.

        continue

    }

    # when the above if statement which checked if an account exists already doesn't execute 
    # this woud indicate the user doesn't exist, so run this else

    else {

        # Using a try catch, I can catch the potential errors
        # that may occur during account creation

        try {

            # Using the New-ADUser command, I will create a new
            # Active Directory user with the parameters from the csv file
            # for the current user being processed in the for loop. using backticks
            # I tell powershell to not end the line and that it is a continuation line
            # I set all the parameters required to make a new user account
            # I am directly referencing the csv data values for the current user being processed in
            # the for loop.

            New-ADUser `
            -Name "$($user.firstname) $($user.lastname)" `
            -GivenName $user.firstname `
            -Surname $user.lastname `
            -SamAccountName $user.username `
            -UserPrincipalName $user.email `
            -EmailAddress $user.personalemail `
            -StreetAddress $user.streetaddress `
            -City $user.city `
            -PostalCode $user.zipcode `
            -State $user.state `
            -Country "CA" `
            -Department $user.department `
            -AccountPassword (ConvertTo-SecureString $user.password -AsPlainText -Force) `
            -ChangePasswordAtLogon $true `
            -OfficePhone $user.telephone `
            -Company $user.company `
            -Path $user.ou `
            -Office $user.physicalDeliveryOfficeName `
            -Enabled $true

            # I use the Add-ADGroupMember with -Identity of the department for the current user being processed in the for loop
            # and then for the members, I add the current user based on their username This will add the user account to the security group

            Add-ADGroupMember -Identity $user.department -Members $user.username

            # Now that the user account was created from my previous commands I verify that the user creation
            # was successful by using and if statement I use the Get-ADUser command with a filter to check if the
            # SamAccountName is equal to the username of the current user being processed in the for loop if so, then run this if statement

            if (Get-ADUser -Filter "SamAccountName -eq '$($user.username)'") {

                # I output some text to the terminal to display that the user account being processed in the for loop
                # was successfully created

                Write-Host "User Account $($user.username) was created Successfully within $($user.department)!" -ForegroundColor Green

            }
        
        }

        # if there was an error within the try block above which contains
        # my New AD User creation then this catch block is ran.
    
        catch {
            
            # I then display which user errored during creation and then the
            # exception message to display the issue that occured

            Write-Host "Error Creating User $($user.username) $($_.Exception.Message)" -ForegroundColor Red

        }

    }
   
}