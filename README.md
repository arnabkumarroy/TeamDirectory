# TeamDirectory

In order to run this project use the following steo before run this project.



# About the Project #

# 1. Writing an overview of this app

This project is created thinking of idea for a IT manager who handle different types of team. With this App the will able to register and create and team and add team member software. It will help to display all of the team member details of their joining details as well project details. It is a very ggod replacement of excel and present in a more precise manner. Easy searchable and presentable.

# 2. Provide some screenshots and information about screens
<p align="center">
  <img width="250" height="400" src="https://github.com/arnabkumarroy/TeamDirectory/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%20XR%20-%202019-02-12%20at%2022.16.05.png">
</p><p align="center">
  <img width="250" height="400" src="https://github.com/arnabkumarroy/TeamDirectory/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%20XR%20-%202019-02-12%20at%2022.17.02.png">
</p><p align="center">
  <img width="250" height="400" src="https://github.com/arnabkumarroy/TeamDirectory/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%20XR%20-%202019-02-12%20at%2022.17.06.png">
</p>
# 3. The libraries you used in this project
        The external libraries used for the project are following
        Firebase and BRYXBanner

# 4. Provide requirements to build and run your app
        Step 1: Install Cocoapods if that is not present in your system with the below command from Command prompt
        $ sudo gem install cocoapods

        Step 2: Go to the project directory of this project in the stystem using command pront and type the following command. 
        It will Create a Podfile if you don't have one:
        $ pod init

        Step 3: Copy paste the following item in the newly created pod file

        #Uncomment the next line to define a global platform for your project
        #platform :ios, '9.0'

        target 'Team Directory' do
         #Comment the next line if you're not using Swift and don't want to use dynamic frameworks
        use_frameworks!

        #Pods for Team Directory
        pod 'Firebase/Core'
        pod 'Firebase/Auth'
        pod 'Firebase/Database'
        pod 'BRYXBanner'
        target 'Team DirectoryTests' do
        inherit! :search_paths
        # Pods for testing
  end

  target 'Team DirectoryUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

Step 4: Then either pod install. It will download all the required dependency from the project.
$ pod install

Step 5: Open Team Directory.xcworkspace from xcode 10.1


# Provide requirements to build and run your app -- Addition Question

## 4a. The iOS version
        Deployment Target: 12.1
## 4b. XCode version
        Latest Xcode: 10.1
## 4c. Swift version
        Swift 4.2
