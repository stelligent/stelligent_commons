# local_dev_box
Generating local vagrant development environments for developers

Create a local self contained environment for app deployment from an already made vagrant box.

Includes Ruby, Rails, Nginx/Passenger, Java, PostgreSQL, Node.js, npm, bower, elasticsearch.

## 1. Installation reqs

* VirtualBox (tested w/ 4.3.20)
* Vagrant (tested w/ 1.7.2)
* Ruby (tested w/ 2.1.4)

## 2. Get going


Clone the repo

```
git clone git@github.com:stelligent/stelligent_commons.git
```

Navigate into my-local-dev-box.

```
cd local_dev_box/my-local-dev-box
```

Add .box to vagrant

```
vagrant box add localdevbox /path/to/[devboxname].box
```

NOTE: If you receive an error when trying to add the localdevbox (saying it already exits), remove the box with the following line:
vagrant box remove localdevbox 

Initialize the box

```
vagrant init localdevbox
```

Remove the Vagrantfile

```
rm Vagrantfile
```

Update the host's local project path to share with the vm, e.g. a web app you're developing locally on the host machine. Creates `vagrant.yml` file and
creates the `Vagrantfile` from `LocalVagrantfile.example`.

```ruby
ruby config_local_vagrant.rb -l /changeme-absolute-path-to-proj-dir
```

Start the development box

```
vagrant up
```

Login

```
vagrant ssh
```

## 3. Verify

```
vagrant ssh
ruby -v
rails -v
java -version
...
```

## 4. Additional configuration (optional)

Existing settings in your vagrant.yml file will be persisted. Only specific changes will occur. You will need to restart your vagrant box for changes to take effect.

Change number of cpus assigned to your VM (default is 2)

```
ruby config_vagrant.rb -c <# of cpus>
```

Change amount of memory assigned to your VM (default is 4096)

```
ruby config_vagrant.rb -m <amount of memory (MB)>
```

Change local project path that you initially set up in step #2

```
ruby config_vagrant.rb -l <absolute-path>
```

Change guestpath on your VM (default is /vagrant_data)

```
ruby config_vagrant.rb -g <absolute-path>
```
