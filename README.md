# ControllerLess

ControllerLess is DSL to DRY controller and Routes using inherited_resources inspired by activeadmin.

### Installation

ControllerLess requires ruby 2.* with rails  3.*-4.* to run.

```sh
gem 'controller_less', '~> 0.0.9.pre'
```
### Basic Usage
Initialize the gem by creating file in ```config/initializers/controller_less.rb```, the basic file will look like this.
```
ControllerLess.setup do
end
```
You will also need to add this line ```ControllerLess.load_routes``` in ```config/routes.rb```.

To use ControllerLess you have to create ```*_cls.rb``` in the ```app/cls``` folder. 
```
ControllerLess.register Post do
end
```
### Namespace
To use namespace pass the parameter of namespace to ```.register``` method checkbelow for example.
```
Controller.register Post, namespace: "Api::V1" do
end
```
### Restricting the Routes and Action Created
By default ControllerLess creates seven actions with their routes using inherited_resources. You can restrict the access by passing options to only method. check the exmaple below
```
Controller.register Post do
    only :index, :show
end
```
### Callbacks 
Following methods are delegate to controller.

```
:respond_to, :_insert_callbacks, :_normalize_callback_options, :after_action, :append_after_action, :append_around_action, :append_before_action, :around_action, :before_action, :prepend_after_action, :prepend_around_action, :prepend_before_action, :skip_action_callback, :skip_after_action, :skip_around_action, :skip_before_action, :skip_filter
```
How to use the callback in ControllerLess check the example below.
```
ControllerLess.register User do
    before_action :authenticate_user! 
end
```
### Strong Parameters
ControllerLess works smooth with Strong Parameters to allow the parameters pass the values to ```permitted_params```. Please check the example below.
```
ControllerLess.register Post do
    permitted_params :title, :create
end
```
### Overriding methods & Add Private methods
You can override method by writing code in controller block. Please the check the example.
```
ControllerLess.register Post do
    controller do
        def index
            @posts = Post.last(5)
        end
    end
end
```
### Bugs and Feedback

If you discover any bug please report it in the issue tracker.
Feedback can be sent to a2ninek [at] yahoo [dot] com.
MIT License. Copyright (c) 2015-2017 Kamal Ejaz.
        
