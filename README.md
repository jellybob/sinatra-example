This is the result of a blog post on creating a testable Sinatra app. If you just want to use it, clone
the repository, and start hacking. Below is the blog post that created it, which can also be found at
http://blog.blankpad.net/2010/07/04/starting-a-testable-sinatra-application/.

I'm getting into using Sinatra for smaller web applications, instead of the behemoth that is Rails.

For many purposes, Rails is still perfect, but I often find that it can be overkill if all you need
is to display a couple of pages, and possibly provide an API. Here's a quick guide on creating a
Sinatra application that can be tested using RSpec and Cucumber.

Install Bundler, and Create a Gemfile
-------------------------------------

[Bundler](http://gembundler.com) lets us manage the list of gems that our application depends on. I'm
using it on all new projects now, so that I don't have to spend half an hour remembering what needs to
be installed before starting.

    gem install bundler
    cd /path/to/example_app
    bundle init

That will create `Gemfile` in the example application's root directory, which we can use to specify the
gems our application needs. Put the following in it for now:

    source :gemcutter

    gem "sinatra"
    gem "unicorn"
    gem "haml"

    group :test do
      gem "cucumber-sinatra"
      gem "cucumber"
      gem "capybara"
      gem "rspec"
    end

Now when you run `bundle install` it'll install any dependencies that are required.

Create a Stub Application
-------------------------

This is going to be a really simple stub application for now, since this article isn't really trying to
teach you how to use Sinatra.

Put the following in `lib/application.rb`.

    require 'sinatra/base'
    require 'haml'

    class Application < Sinatra::Base
      set :app_file, __FILE__
      set :inline_templates, true

      get '/' do
        haml :index
      end
    end

    __END__
    @@ index
    !!!
    %html
      %head
        %title A test application
      %body
        %h1 Hello, world!

Just to check that it's all working, dump this in `config.ru`, which will load everything using 
Bundler.

    $: << "lib"

    require 'application'
    run Application

And run it with `bundle exec unicorn` - loading `bundle exec` ensures all the gems specified have been
loaded from the appropriate location before running the application itself.

Add a Slice of Cucumber
-----------------------

Now we're going to make this testable with Cucumber:

    bundle exec cucumber-sinatra init Application lib/application.rb

That will tell you about the files it's generating. Lets have a look at `features/support/env.rb` which
is where Cucumber gets configured. You'll see that it simply loads `application.rb` and then tells
Capybara (the component that actually runs web apps) that the application under test is `Application`.

Lets write a feature to test that our simple application is in fact working. Put this in 
`features/hello.feature`.

    Feature: Welcoming new developers
    As a software developer
    I want the world to be welcomed
    So I get a fuzzy feeling of success

    Scenario: Loading the welcome page
      When I go to the home page
      Then I should see "Hello, world!"

When you run it with `bundle exec features/hello.feature` it should pass.

Cucumber Profiles
-----------------

By using profiles we can make use of the WIP (Work in Progress) tag to reduce the time it takes to run
our features when we're only interested in one or two features.

Start by creating `cucumber.yml` and put the following in it:
    
    <% common = "--strict features" %>
    default: --format progress <%= common %>
    wip: --format pretty --tags @wip <%= common %>
    ok: --format pretty --tags ~@wip <%= common %>

This will provide you with three profiles, `default`, `wip`, and `ok` for different tasks. `default` will
run all features, in progress mode - this is probably the one you want to use for continuous integration.

`wip` and `ok` are opposites, with `wip` running anything with the `@wip` tag applied, and `ok` doing
the opposite.

Now lets create some rake tasks to run them - put this in `Rakefile`:

    require 'cucumber'
    require 'cucumber/rake/task'
    
    namespace :features do
      Cucumber::Rake::Task.new(:all) do |t|
        t.profile = "default"
      end

      Cucumber::Rake::Task.new(:ok) do |t|
        t.profile = "ok"
      end
      
      Cucumber::Rake::Task.new(:all) do |t|
        t.profile = "wip"
      end
    end

Now when you run the rake tasks you'll get the appropriate features run.

And now for some RSpec
----------------------

Finally, we're going to set up RSpec. This probably won't be at all unusual to you if you've done it
before, but I'm going to demonstrate it as well.

In your Rakefile:

    require 'spec/rake/spectask'
    
    namespace :spec do
      desc "Run all examples"
      Spec::Rake::SpecTask.new('spec') do |t|
        t.spec_files = FileList['spec/**/*_spec.rb']
      end
    end

Then put this in `spec/spec_helper.rb` to make sure anything in lib/ can be loaded correctly:

    $: << File.expand_path(File.dirname(__FILE__) + '/../lib')

And that's about it. Create a `spec` directory, and start filling it up with specs ending in `_spec.rb`,
like this one (in `spec/application_spec.rb`):
    
    require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
    require 'application'

    describe Application do
      it { should_not be_nil }
    end

Now when you run `rake spec:all` if all went well you'll see a passing spec.

On With the Code
----------------

That's as far as I'm going to go with this for now. Go write some code.

You can find the end result of this in the [sinatra-example](http://github.com/jellybob/sinatra-example)
project under my [GitHub account](http://github.com/jellybob/).
