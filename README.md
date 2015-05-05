stelligent_commons
==================

Scripts and other utilities we commonly use at Stelligent


# Development Environment
========
* **[create_dev_env.json](https://github.com/stelligent/stelligent_commons/blob/master/create_dev_env.json)** -- this CloudFormation template creates a development environment on AWS EC2 that runs Ruby, Git among other necessary resources.

# VPC Networking

## Basic Usage to create a VPC

Prerequisites: Ruby 2.1 with Bundler should be installed.

1. From the stelligent_commons root directory, run:

        bundle install

2. Run one of the example scripts under the bin directory to generate a CloudFormation template.  The name of the script
   roughly reflects the type of VPC it is going to create.

        bin/generate_private_vpc > private_vpc_cfn_template.json
        bin/generate_3az_vpc --ip-to-allow-to-bastion xx.xx.xx.xx --nat-keypair-name key-name --bastion-keypair-name key-name > 3az_vpc_cfn_template.json
        bin/generate_typical_2az_vpc --ip-to-allow-to-bastion xx.xx.xx.xx --nat-keypair-name key-name --bastion-keypair-name key-name > 2az_vpc_cfn_template.json
NOTE: --nat-keypair-name and --bastion-keypair-name are optional and will default to 'nat_keypair' and 'bastion_keypair', respectively. 

3. Feed the template to CloudFormation through the method of choice: AWS CLI, console, or use the CfnExecutor object.

## Customizing the created VPC

The VpcCfnGenerator is meant to be flexible enough (at the cost of a fair amount of complexity and over-engineering!?!??) to create a variety of different
VPC configurations.  The typical customization will be to set the cidr blocks and to decide how many subnets of each type to
create (public, natt-ed, private).

The basic tool is meant more for a developer to use instead of an "end user", but calls to VpcCfnGenerator
should be wrapped up in a one-click script that can be incorporated into a deployment pipeline or just used by an arbitrary person
without programming experience.

It would also be possible to make an elaborate CLI interface to exercise the API if desired.

To create a new script, one can use the examples in the bin directory as a starting point.  From here you can either add
command line arguments or customize the VPC created as desired.  The basic flow of the script is:

0. Elicit any command line arguments such as IP addresses of hosts that should be allowed ingress on port 22 to the bastion
1. Construct a VpcDescription object

      This is where all the customizations will happen.  More subnets, less subnets, different masks, etc. Include
      a bastion, don't include one, etc.

2. Construct a VpcCfnGenerator object
3. Execute emit against VpcCfnGenerator

## Extending the VpcCfnGenerator and further work

* would be good to add support for an OpenVPN server
* setup HA NAT
* setup HA OpenVPN
* the implementation for VpcCfnGenerator is "brute force" at this point.  Perhaps interesting to decompose into a better dsl that encapsulates some of the horrific hash building

## Testing the created VPC

In order to test that the created VPC matches expectations, serverspec + stelligent/serverspec-aws-resources can be
used to specify the expectations.  For the three stock scripts, there are matching serverspec specifications
under serverspec/default.

To execute them, you must pass in the VPC_ID for all tests, and then BASTION_INGRESS except for the private VPC which has no bastion.
The SPEC_OPTS setting will use tags to determine which test to run - so pick the tag according to which script you have run previously.
If you have yet to actually construct a VPC to test, these tests should fail pretty much across the board depending on
what VPC_ID is specified.

    bundle install
    VPC_ID=vpc-xxxxx BASTION_INGRESS=xx.xx.xx.xx SPEC_OPTS="-t basic_two_az" bundle exec rake serverspec
    VPC_ID=vpc-xxxxx BASTION_INGRESS=xx.xx.xx.xx SPEC_OPTS="-t three_az" bundle exec rake serverspec
    VPC_ID=vpc-xxxxx SPEC_OPTS="-t private" bundle exec rake serverspec

## Running unit tests against VpcCfnGenerator
    bundle exec rspec


