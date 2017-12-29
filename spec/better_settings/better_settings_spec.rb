require 'spec_helper'
require 'support/settings'

describe BetterSettings do
  def new_settings(value)
    Settings.new(value, parent: 'new_settings')
  end

  it 'should access settings' do
    expect(Settings.setting2).to eq 5
  end

  it 'should access nested settings' do
    expect(Settings.setting1.setting1_child).to eq 'saweet'
  end

  it 'should access settings in nested arrays' do
    expect(Settings.array.first.name).to eq 'first'
  end

  it 'should access deep nested settings' do
    expect(Settings.setting1.deep.another).to eq 'my value'
  end

  it 'should access extra deep nested settings' do
    expect(Settings.setting1.deep.child.value).to eq 2
  end

  it 'should enable erb' do
    expect(Settings.setting3).to eq 25
  end

  it 'should namespace settings' do
    expect(DevSettings.language.haskell.paradigm).to eq 'functional'
    expect(DevSettings.language.smalltalk.paradigm).to eq 'object-oriented'
    expect(DevSettings.environment).to eq 'development'
  end

  it 'should distinguish nested keys' do
    expect(Settings.language.haskell.paradigm).to eq 'functional'
    expect(Settings.language.smalltalk.paradigm).to eq 'object oriented'
  end

  it 'should not override global methods' do
    expect(Settings.global).to eq 'GLOBAL'
    expect(Settings.custom).to eq 'CUSTOM'
  end

  it 'should raise a helpful error message' do
    expect {
      Settings.missing
    }.to raise_error(BetterSettings::MissingSetting, /Missing setting 'missing' in/)
    expect {
      Settings.language.missing
    }.to raise_error(BetterSettings::MissingSetting, /Missing setting 'missing' in 'language' section/)
  end

  it 'should raise an error on a nil source argument' do
    expect { NoSource.foo.bar }.to raise_error(ArgumentError, '`source` must be specified for the settings')
  end

  it 'should support instance usage as well' do
    expect(new_settings(Settings.setting1).setting1_child).to eq 'saweet'
  end

  it 'should handle invalid name settings' do
    expect {
      new_settings('some-dash-setting#' => 'dashtastic')
    }.to raise_error(BetterSettings::InvalidSettingKey)
  end

  it 'should handle settings with nil value' do
    expect(Settings.nil).to eq nil
  end

  it 'should handle settings with false value' do
    expect(Settings.false).to eq false
  end

  # If .name is called on BetterSettings itself, handle appropriately
  # by delegating to Hash
  it 'should have the parent class always respond with Module.name' do
    expect(BetterSettings.name).to eq 'BetterSettings'
  end

  # If .name is not a property, delegate to superclass
  it 'should respond with Module.name' do
    expect(DevSettings.name).to eq 'DevSettings'
  end

  # If .name is a property, respond with that instead of delegating to superclass
  it 'should allow a name setting to be overriden' do
    expect(Settings.name).to eq 'test'
  end

  describe 'to_h' do
    it 'should handle empty file' do
      expect(NoSettings.to_h).to be_empty
    end

    it 'should be similar to the internal representation' do
      expect(settings = Settings.send(:root_settings)).to be_is_a(Settings)
      expect(hash = settings.send(:settings)).to be_is_a(Hash)
      expect(Settings.to_h).to eq hash
    end

    it 'should not mutate the original when getting a copy' do
      result = Settings.language.to_h.merge('haskell' => 'awesome')
      expect(result.class).to eq Hash
      expect(result).to eq(
        'haskell' => 'awesome',
        'smalltalk' => { 'paradigm' => 'object oriented' },
      )
      expect(Settings.language.haskell.paradigm).to eq('functional')
      expect(Settings.language).not_to eq Settings.language.merge('paradigm' => 'functional')
    end
  end

  describe '#to_hash' do
    it 'should return a new instance of a Hash object' do
      expect(Settings.to_hash).to be_kind_of(Hash)
      expect(Settings.to_hash.class.name).to eq 'Hash'
      expect(Settings.to_hash.object_id).not_to eq Settings.object_id
    end
  end
end
