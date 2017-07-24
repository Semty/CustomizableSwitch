Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "CustomizableSwitch"
s.summary = "Customize switches!"
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Ruslan Timchenko" => "rustimchek@mail.ru" }

# For example,
# s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/Semty/CustomizableSwitch"

# For example,
# s.homepage = "https://github.com/JRG-Developer/CustomizableSwitch"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/Semty/CustomizableSwitch.git", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/CustomizableSwitch.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"
s.framework = "Foundation"

# 8
s.source_files = "CustomizableSwitch/**/*.{swift}"

# 9
s.resources = "CustomizableSwitch/**/*.{png,jpeg,jpg,storyboard,xib}"
end
