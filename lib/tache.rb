#!/usr/bin/env ruby
# encoding: UTF-8

# Classe d'une tache

UNE_HEURE = 3600
UN_JOUR   = UNE_HEURE * 24
UNE_ANNEE = UN_JOUR * 365


class Tache
  attr_reader :id, :tache, :pour, :hot

  def initialize hdata
    # On dispatche les données de la tâche
    hdata.each{|k,v| instance_variable_set("@#{k}", v)}
  end

  def echeance
    @echeance ||= echeance_from_pour
  end

  # ---------------------------------------------------------------------
  #   Méthodes d'helper HTML
  # ---------------------------------------------------------------------

  def as_li
    tid = "tache-#{id}"
    c = "<li id='#{tid}' class='tache #{style}'>"
    # Toutes les infos
    c << div_infos
    # Le CB
    c << "<input type='checkbox' id='#{tid}-cb' />"
    # La tache
    c << "<label for='#{tid}-cb' class='tache'>#{tache}</label>"
    c << '</li>'
    return c
  end

  # ---------------------------------------------------------------------
  # Méthodes d'helper private HTML
  # ---------------------------------------------------------------------

  # /* private */
  def div_infos
    c = "<div class='infos'>"
    c << "<span class='echeance'>#{echeance_h} (dans #{reste_h})</span>"
    c << "</div>"
    return c
  end



  private

    def outofdate?
      echeance < Time.now
    end

    # Style de la tache en fonction de l'échéance
    def style
      if outofdate?
        'warning'
      else
        if @actual
          'orange'
        elsif reste_jours > 6
          'cool'
        else
          if @hot
            'orange'
          else
            ''
          end
        end
      end
    end

    # L'échéance en format humain
    def echeance_h
      @echeance_h ||= echeance.strftime('%d %m %Y')
    end

    # Le temps qu'il reste en jour jusqu'à l'échéance en nombre de jours ou d'heures
    def reste_jours
      @reste || (echeance - Time.now) / UN_JOUR
    end
    # Le temps restant, en version humaine
    def reste_h
      @reste ||= begin
        if outofdate?
          ''
        else
          r = echeance - Time.now
          if r > UN_JOUR
            r = (r / UN_JOUR).to_i
            s = r > 1 ? 's' : ''
            "#{r} jour#{s}"
          else
            r = (r / UNE_HEURE).to_i
            s = r > 1 ? 's' : ''
            "#{r} heure#{s}"
          end
        end
      end
    end

    def echeance_from_pour
      now = Time.now
      case pour
      when nil
        return Time.now + UNE_ANNEE
      when 'auj'
        return Time.new(now.year, now.month, now.day, 23,59,59)
      when 'dem'
        return Time.new(now.year, now.month, now.day + 1, 23,59,59) # + UN_JOUR
      else
        jour, mois, annee = @pour.split(' ')
      end
      Time.new((annee|| Time.now.year).to_i, (mois||Time.now.month + 1).to_i, jour.to_i, 23, 59, 59)
    end
end
