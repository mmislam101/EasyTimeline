Pod::Spec.new do |s|
s.name             = "EasyTimeline"
s.version          = "1.0.1"
s.summary          = "Keep track of more complex timing needs for your applications"
s.description      = <<-DESC
<p>Sometimes you need things to happen at specific times and things.</p>
<p>What if you want something to happen every 2 seconds and then at the 7th second something else to happen? Or if you want to pause everything for a while and then resume later?</p>
<p>That's where <strong>EasyTimeline</strong> comes into play.</p>
DESC
s.homepage         = "https://github.com/mmislam101/EasyTimeline"
s.license          = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
s.author           = { "Mohammed Islam" => "ksitech101@gmail.com" }
s.source           = { :git => "https://github.com/mmislam101/EasyTimeline.git", :tag => s.version.to_s }

s.platform         = :ios, '6.0'
s.requires_arc     = true

s.source_files     = 'EasyTimeline'
end
