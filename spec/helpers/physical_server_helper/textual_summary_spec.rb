describe PhysicalServerHelper::TextualSummary do
  it "#textual_ipv4" do
    network = FactoryGirl.build(:network, :ipaddress => "192.168.1.1")
    guest_device = FactoryGirl.build(:guest_device, :network => network)
    hardware = FactoryGirl.build(:hardware, :guest_devices => [guest_device])
    computer_system = FactoryGirl.build(:computer_system, :hardware => hardware)
    @record = FactoryGirl.build(:physical_server, :computer_system => computer_system)

    result = helper.textual_ipv4
    expect(result[:label]).to eq("IPv4 Address")
    expect(result[:value]).to eq([{:link => "https://192.168.1.1", :external => true, :value => "192.168.1.1"}])

    network.ipaddress = "192.168.1.1,192.168.1.2"
    result = helper.textual_ipv4
    expect(result[:label]).to eq("IPv4 Address")
    expect(result[:value]).to eq(
      [
        {:link => "https://192.168.1.1", :external => true, :value => "192.168.1.1"},
        {:link => "https://192.168.1.2", :external => true, :value => "192.168.1.2"}
      ]
    )

    network.ipaddress = "192.168.1.1, 192.168.1.2"
    result = helper.textual_ipv4
    expect(result[:label]).to eq("IPv4 Address")
    expect(result[:value]).to eq(
      [
        {:link => "https://192.168.1.1", :external => true, :value => "192.168.1.1"},
        {:link => "https://192.168.1.2", :external => true, :value => "192.168.1.2"}
      ]
    )

    network.ipaddress = ""
    result = helper.textual_ipv4
    expect(result[:label]).to eq("IPv4 Address")
    expect(result[:value]).to eq([])
  end

  include_examples "textual_group", "Properties", %i(
    name
    model
    product_name
    manufacturer
    machine_type
    serial_number
    ems_ref
    capacity
    memory
    cores
    network_devices
    storage_devices
    health_state
    loc_led_state
  )

  include_examples "textual_group", "Relationships", %i(host ext_management_system physical_rack physical_chassis physical_switches)

  include_examples "textual_group", "Management Networks", %i(mac ipv4 ipv6), "management_networks"

  include_examples "textual_group", "Asset Details", %i(
    support_contact
    description
    location
    room_id
    rack_name
    lowest_rack_unit
  ), "asset_details"

  include_examples "textual_group", "Power Management", %i(power_state), "power_management"

  include_examples "textual_group", "Firmware Compliance", %i(compliance_name compliance_status), "firmware_compliance"

  include_examples "textual_group_smart_management"
end
