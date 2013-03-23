# encoding: utf-8

require 'battle_tank/config_loader'

module BattleTank
  class Client
    class Tank
      def initialize(model)
        @model = model
        @definition = all[model]
        direction = :up
      end

      attr_accessor :x, :y, :width, :height, :direction

      def width
        show.first.length
      end

      def height
        show.length
      end

      def show
        definition['model']["#{direction.to_s}"]
      end

      def bullet
        definition['bullet']
      end

      def to_h
        {
          "type" => "tank",
          "model" => model,
          "x" => x,
          "y" => y,
          "dir" => direction.to_s
        }
      end

      def self.from_hash(hash)
        BattleTank::Client::Tank.new(hash['model']).tap do |tank|
          tank.direction = hash['dir'].to_sym
          tank.x = hash['x']
          tank.y = hash['y']
        end
      end


      private

      def all
        {
          "cannon" => {
            "model" =>  {
              "left" =>  [
                "  ═══",
                "╠══■│",
                "  ═══"
              ],
              "right" =>  [
                "═══  ",
                "│■══╣",
                "═══  "
              ],
              "up" =>  [
                " ═╦═ ",
                "║ ║ ║",
                "║─▀─║"
              ],
              "down" =>  [
                "║─▄─║",
                "║ ║ ║",
                " ═╩═ "
              ]
            },
            "bullet" =>  "■"
          },

          "engineer" => {
            "model" =>  {
              "left" =>  [
                "■■■■■",
                "┼─┤■│",
                "■■■■■"
              ],
              "right" =>  [
                "■■■■■",
                "┼─┤■│",
                "■■■■■"
              ],
              "up" => [
                "█─┼─█",
                "█─┼─█",
                "█─▀─█"
              ],
              "down" => [
                "█─▄─█",
                "█─┼─█",
                "█─┼─█"
              ],
            },
            "bullet" => "."
          },
          "heavy" => {

            "model" =>  {
              "left" =>  [
                "■■■■■",
                "┼─┤■│",
                "■■■■■"
              ],
              "right" =>  [
                "■■■■■",
                "│■│─┼",
                "■■■■■"
              ],
              "up" => [
                "█─┼─█",
                "█─┼─█",
                "█─▀─█"
              ],
              "down" => [
                "█─▄─█",
                "█─┼─█",
                "█─┼─█"
              ],
            },
            "bullet" => "."
          },
          "light" => {
            "model" => {
              "left" => [
                "═════",
                "──o |",
                "═════"
              ],
              "right" => [
                "═════",
                "| o──",
                "═════"
              ],
              "up" => [
                "║ | ║",
                "║ o ║",
                "║───║"
              ],
              "down" => [
                "║───║",
                "║ o ║",
                "║ | ║"
              ]
            },
            "bullet" => ""
          },
          "medium" => {
            "model" => {
              "left" => [
                "═════",
                "══■ │",
                "═════"
              ],
              "right" => [
                "═════",
                "│ ■══",
                "═════"
              ],
              "up" => [
                "║ ║ ║",
                "║ ▀ ║",
                "║───║"
              ],
              "down" => [
                "║───║",
                "║ ▄ ║",
                "║ ║ ║"
              ]
            },
            "bullet" => "o"
          },
          "miner" => {
            "model" => {
              "left" => [
                "■■■■■",
                "─■ o│",
                "■■■■■"
              ],
              "right" => [
                "■■■■■",
                "│o ■─",
                "■■■■■"
              ],
              "up" => [
                "█ | █",
                "█ ▀ █",
                "█─o─█"
              ],
              "down" => [
                "█─o─█",
                "█ ▄ █",
                "█ | █"
              ]
            },
            "bullet" => "Ⓧ"
          }

        }


      end

      attr_reader  :definition, :model
    end
  end
end
