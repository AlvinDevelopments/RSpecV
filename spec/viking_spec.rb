require 'viking.rb'

describe Viking do
  describe 'basic tests' do
    let(:bow){Bow.new()}
    let(:axe){Axe.new()}
    let(:viking_noob){Viking.new("noobman")}
    let(:viking_pro){Viking.new("hotshot")}
    let(:fist){Fists.new()}

    before(:each) do

    end

    it 'Passing a name to a new Viking sets that name attribute' do
      viking_name = "Alvin"
      expect(Viking.new(viking_name).name).to eq(viking_name)
    end

    it 'Passing a health attribute to a new Viking sets that health attribute' do
      viking_health = 20
      expect(Viking.new("noobman", viking_health).health).to eq(viking_health)
    end

    it 'health cannot be overwritten after its been set on initialize' do
      expect{viking_noob.health = 20}.to raise_error(NoMethodError)
    end

    it 'A Vikings weapon starts out nil by default' do
      expect(viking_noob.weapon).to eq(nil)
    end

    it 'Picking up a Weapon sets it as the Vikings weapon' do
      viking_noob.pick_up_weapon(bow)
      expect(viking_noob.weapon).not_to eq(nil)
    end

    it 'Picking up a non-Weapon raises an exception' do
      expect do
        viking_noob.pick_up_weapon(Viking.new())
      end.to raise_exception
    end

    it 'Picking up a Weapon sets it as the Vikings weapon' do
      viking_noob.pick_up_weapon(bow)
      viking_noob.pick_up_weapon(axe)
      expect(viking_noob.weapon).to eq(axe)
    end

    it 'Dropping a Vikings weapon leaves the Viking weaponless' do
      viking_noob.pick_up_weapon(bow)
      viking_noob.drop_weapon
      expect(viking_noob.weapon).to eq(nil)
    end

    it 'The receive_attack method reduces that Vikings health by the specified amount' do
      viking_noob.receive_attack(20)
      expect(viking_noob.health).to eq(80)
    end

    it 'The receive_attack method calls the take_damage method' do
      expect(viking_noob).to receive(:take_damage)
      viking_noob.receive_attack(20)
    end

    it 'attacking another Viking causes the recipients health to drop' do
      initial_health = viking_pro.health
      viking_noob.attack(viking_pro)
      expect(viking_pro.health).to be < initial_health
    end

    it 'attacking another Viking calls that Vikings take_damage method' do
      expect(viking_pro).to receive(:take_damage)
      viking_noob.attack(viking_pro)
    end

    it 'attacking with no weapon runs damage_with_fists' do
      viking_noob.drop_weapon
      allow(viking_noob).to receive(:damage_with_fists).and_return(fist.use * viking_noob.strength)
      expect(viking_noob).to receive(:damage_with_fists)
      viking_noob.attack(viking_pro)
    end

    it 'attacking with no weapon deals Fists multiplier times strength damage' do
      initial_health = viking_pro.health
      viking_noob.drop_weapon
      viking_noob.attack(viking_pro)
      final_health = viking_pro.health
      expect(initial_health-final_health).to eq(viking_noob.strength * fist.use)
    end

    it 'attacking with a weapon runs damage_with_weapon' do
      viking_noob.pick_up_weapon(bow)
      allow(viking_noob).to receive(:damage_with_weapon).and_return(bow.use * viking_noob.strength)
      expect(viking_noob).to receive(:damage_with_weapon)
      viking_noob.attack(viking_pro)
    end

    it 'attacking with a weapon deals damage equal to the Vikings strength times that Weapons multiplier' do
      initial_health = viking_pro.health
      viking_noob.pick_up_weapon(bow)
      viking_noob.attack(viking_pro)
      final_health = viking_pro.health
      expect(initial_health-final_health).to eq(viking_noob.strength * bow.use)
    end

    it 'attacking using a Bow without enough arrows uses Fists instead' do
      allow(bow).to receive(:use).and_raise("error")
      allow(viking_noob).to receive(:damage_with_fists).and_return(fist.use * viking_noob.strength)
      expect(viking_noob).to receive(:damage_with_fists)
      viking_noob.pick_up_weapon(bow)
      viking_noob.attack(viking_pro)
    end


    it 'Killing a Viking raises an error' do
      allow(viking_pro).to receive(:check_death).and_raise(Exception)
      expect do
        viking_noob.attack(viking_pro)
      end.to raise_exception


    end




  end

end
