# TeamDirectory

In order to run this project use the following steo before run this project.

Step 1: Install Cocoapods if that is not present in your system with the below command from Command prompt
$ sudo gem install cocoapods

Step 2: Go to the project directory of this project in the stystem using command pront and type the following command. 
        It will Create a Podfile if you don't have one:
$ pod init

Step 3: Copy paste the following item in the newly created pod file

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Team Directory' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Team Directory
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
