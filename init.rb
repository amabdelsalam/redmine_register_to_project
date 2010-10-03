require 'redmine'

Redmine::Plugin.register :redmine_register_to_project do
  name 'Redmine Register To Project plugin'
  author 'Ahmed Abdelsalam'
  description 'This is a plugin for Redmine'
  version '0.0.3'
  
  settings({
             :partial => 'settings/register_to_project',
             :default => {
               'projects' => []
             }})
  
   ENV['RECAPTCHA_PUBLIC_KEY']  = '6LfMqrwSAAAAAI3oLTsVwopZ0RPU4FeVg8WRCKqw'
  ENV['RECAPTCHA_PRIVATE_KEY'] = '6LfMqrwSAAAAAJftdYEOZNVOQ3zTDyar_HjssQJ3'
  
end
