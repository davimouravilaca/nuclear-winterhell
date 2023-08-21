#==============================================================================
# Resident Evil Like Weapons System
#==============================================================================
#------------------------------------------------------------------------------
# Créditos: Leon-S.K --- ou --- Andre Luiz Marques Torres Micheletti
#==============================================================================

#------------------------------------------------------------------------------
# ARMAS A SEREM USADAS PELO SCRIPT
#------------------------------------------------------------------------------
module Weapons_To_Be_Used
#------------------------------------------------------------------------------.
# Para criar uma arma, copie: Armas[id] = [a, b, c, d, e] e mude:
# ID = Id da arma no database; a = id do item para ser o cartucho da arma
# b = maximo de balas em um cartucho; c = tempo de espera para o proximo tiro
# d = som de tiro, reload e no_ammo
# e = zoom do icone no player (padrao = 1)
Armas = {}; Granadas = {} 
Armas[62] = [17, 15, 60, "pistol"]
Armas[63] = [18, 7, 80, "shot"]
Armas[64] = [19, 50, 10, "smg"]
Armas[65] = [20, 9, 60, "wes"]
Armas[66] = [21, 1, 90, "rocket"]
#----------------------------------------------------------------------------
#~ Você pode ainda criar armas com efeito de area (explosivos)
#~ Colocando no comentario da arma => "area"
#~  
#~ Você pode ainda criar armas com efeito de perfuração (sniper)
#~ Colocando no comentario da arma => "pierce x"
#~ Onde x é a qnt de inimigos que ela pode atravessar
#----------------------------------------------------------------------------
end
#==============================================================================
  
  #------------------------------------------------------------------------------
  # AREA NAO EDITAVEl!
  #------------------------------------------------------------------------------

  class Scene_Map < Scene_Base
  
  include Weapons_To_Be_Used
  alias my_start start
  def start
    my_start
    create_global_weapons(Armas) if $weapons.nil?
  end
  
  def create_global_weapons(armas)
    $weapons = []
    armas.each { |arma|
      p1 = $data_weapons[arma[0]]
      p2 = $data_items[arma[1][0]]
      p3 = arma[1][1]
      p4 = arma[1][2]
      p5 = arma[1][3]
      $weapons.push(Abs_Weapon.new(p1, p2, p3, p4, p5))
    }
  end
end

#----------------------------------------------------------------------------------#
class Abs_Weapon
  
  attr_accessor :recover
  attr_accessor :magazine
  attr_accessor :bullets
  attr_accessor :max
  attr_accessor :weapon
  attr_accessor :iconset_id
  attr_accessor :name
  attr_accessor :wav_name
  attr_reader   :area
  attr_reader   :pierce
  attr_reader   :pierce_num
  
  def initialize(weapon, magazine, max, recover, wav_name)
    @weapon, @magazine, @max, @recover, @wav_name = weapon, magazine, max, recover, wav_name
    @bullets = 0; @iconset_id = @magazine.icon_index; @name = @weapon.name
    @pierce = false; @area = false
    if @weapon.note.include?("area")
      @area = true
    else
      @area = false
    end
    if @weapon.note.include?("pierce=")
      return if @weapon.note.include?("area")
      number = @weapon.note.sub("pierce=","")
      @pierce_num = number.to_i
      @pierce = true
      if @pierce_num == nil
        @pierce_num = Module_Of_Config::Pierce_Enemies
      end
    else
      @pierce = false
    end
  end
end

#----------------------------------------------------------------------------------#
class Game_Actor < Game_Battler
  
  alias :my_def :change_equip
  
  def change_equip(slot_id, item)
    if slot_id == 0
      for weapon in $weapons
        break if item == nil
        if weapon.weapon.id  == item.id
          $game_player.equipped_weapon = weapon
          $game_player.equipped_weapon.bullets = 0 if $game_player.equipped_weapon.bullets.nil?
          break
        else
          $game_player.equipped_weapon = nil
        end
      end
      if item == nil
        $game_player.equipped_weapon = nil
      end
      my_def(slot_id, item)
    else
      my_def(slot_id, item)
    end
  end
end
