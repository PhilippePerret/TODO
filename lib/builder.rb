#!/usr/bin/env ruby
# encoding: UTF-8

# Le constructeur du fichier des tâches

require 'yaml'
require 'sass'
require './lib/taches.rb'
require './lib/tache.rb'

class Builder
  class << self

    # Méthode principale construisant la liste des tâches
    #
    # @retourne self (pour chainage)
    #
    def build options = nil
      File.exist?(path) && File.unlink(path)
      write head_html
      write '<body>'
      liste_taches
      write end_html

      if options && options[:open]
        `open "#{path}"`
      end

      return self
    end

    def liste_taches
      write '<ul id="taches">'
      Taches.new.sort.each{|tache| write tache.as_li}
      write '</ul>'
    end

    # ---------------------------------------------------------------------
    #   Méthodes fonctionnelles
    # ---------------------------------------------------------------------

    # Écrit le code +code+ dans le fichier HTML
    def write code
      fref.write code
    end

    private

      def fref
        @fref ||= File.open(path,'a')
      end
      def path
        @path ||= File.join(folder, 'lib', 'taches.html')
      end

      def path_yaml_file
        @path_yaml_file ||= File.join(folder, 'TACHES.yaml')
      end
      def path_run_file
        @path_run_file ||= File.join(folder, '__run__.rb')
      end

      def folder
        @folder ||= File.expand_path('.')
      end



      # ---------------------------------------------------------------------
      #   ÉLÉMENTS HTML
      # ---------------------------------------------------------------------
      SASS_OPTIONS = {
        line_comments:  false,
        syntax:         :sass,
        style:          :compressed
      }

      def styles_css
        Sass.compile(File.read('./lib/todo.sass'), SASS_OPTIONS)
      end

      def head_html
        <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>TODO list</title>
    <style type="text/css">#{styles_css}</style>
  </head>
        HTML
      end

      def end_html
        lien_open_taches +
        '</body></html>'
      end

      def lien_open_taches
        '<div class="tiny">'+
          "<a href='atm:open?url=file://#{path_yaml_file}'>Ouvrir le fichier des tâches</a>"+
          ' – ' +
          "<a href='atm:open?url=file://#{path_run_file}'>Actualiser les tâches</a>"+
        '</div>'
      end

  end
end
