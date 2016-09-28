task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/bufferize.zip autoload/ plugin/ doc/bufferize.txt'
end
