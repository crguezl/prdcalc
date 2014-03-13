task :default => :serve

task :serve => [ 'public/styles.css', 'public/javascript/main.js' ] do
  sh "rackup"
end

task :css => 'public/styles.css'

file 'public/styles.css' => 'views/styles.scss' do
  sh "sass views/styles.scss public/styles.css"
end

task :js => 'public/javascript/main.js'

file 'public/javascript/main.js' => ['public/javascript', 'views/main.coffee'] do
  sh "coffee -c -o public/javascript/ views/main.coffee"
end

directory 'public/javascript' 

task :clean do
  sh "rm -f public/styles.css public/javascript/main.js"
end
