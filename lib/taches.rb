#!/usr/bin/env ruby -wKU
# encoding: UTF-8

# Classe des Taches comme un ensemble

class Taches

  def taches
    @taches ||= begin
      id = 0
      taches_yaml.collect do |htache|
        id += 1
        Tache.new(htache.merge(id: id))
      end
    end
  end
  alias :all :taches

  # Classe la liste des taches par échéance, de la plus proche à la plus
  # lointaine.
  # @retourne self, pour le chainage
  def sort
    @taches = taches.sort_by{|t| t.echeance }
    return self
  end
  def each
    taches.each do |tache|
      yield tache
    end
  end

  def taches_yaml
    @taches_yaml ||= YAML.load_file('TACHES.yaml')
  end
end
