describe 'vpc_description' do

  it 'should bail on nil parameters' do
    vpc_description = VpcDescription.new

    expect { vpc_description.add_vpg(nil) }.to_raise ArgumentError

    expect { vpc_description.add_bastion(nil, Object.new, Object.new, Object.new)}.to_raise ArgumentError
    expect { vpc_description.add_bastion(Object.new, nil, Object.new, Object.new)}.to_raise ArgumentError
    expect { vpc_description.add_bastion(Object.new, Object.new, nil, Object.new)}.to_raise ArgumentError
    expect { vpc_description.add_bastion(Object.new, Object.new, Object.new, nil)}.to_raise ArgumentError

    expect { vpc_description.add_nat(nil, Object.new) }.to_raise ArgumentError
    expect { vpc_description.add_nat(Object.new, nil) }.to_raise ArgumentError
  end

  it 'should not validate a nat or bastion with 0 public subnets' do

  end

  it 'should not validate a vgw with 0 private subnets' do

  end
end