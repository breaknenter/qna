shared_examples_for 'Returns all public fields' do
  it 'returns all public fields' do
    attributes.each do |attr|
      expect(resource[attr]).to eq object.send(attr).as_json
    end
  end
end

shared_examples_for 'Does not return private fields' do
  it 'does not return private fields' do
    private_fields = %w[password encrypted_password]

    expect(json).to_not have_key(private_fields)
  end
end
