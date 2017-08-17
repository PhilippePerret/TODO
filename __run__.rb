#!/usr/bin/env ruby
# encoding: UTF-8

# ---------------------------------------------------------------------
# LANCER CE FICHIER (CMD + i dans Atom) POUR ACTUALISER LES TACHES
#
# Les tâches doivent avoir été définies dans le fichier TACHES.yaml
# ---------------------------------------------------------------------

require './lib/builder'
Builder.build(open: true)
