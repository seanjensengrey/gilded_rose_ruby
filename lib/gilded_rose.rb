# -*- immutable: string -*-


require 'functional'

Item = Struct.new(:name, :sell_in, :quality)

class Op < Struct.new :item, :quality, :sell_in
  def initialize(item, quality=nil, sell_in=-1)
    super
  end
end

class Object
  include Functional::PatternMatching
  private
  defn(:quality_clamp, Item) { |item|
    if item.quality < 0
      item.quality = 0
    end
    if item.quality > 50
      item.quality = 50
    end
    item
  }

  defn(:regular, Item) { |item|
    op = Op.new(item)
    if item.sell_in <= 0
      op.quality = -2
    else
      op.quality = -1
    end
    op
  }

  defn(:brie, Op) { |op|
    op.quality *= -1
    op
  }

  defn(:backstage, Item) { |item|
    op = Op.new(item)
    case item.sell_in
      when 11..Float::INFINITY
        op.quality = 1
      when 6..10
        op.quality = 2
      when 1..5
        op.quality = 3
      when -Float::INFINITY..0
        op.quality = 0
    end
    op
  }

  defn(:sulfuras, Item) { |item|
    op = Op.new(item)
    item.quality = 80
    op.quality = nil
    op.sell_in = nil
    op
  }

  defn(:conjured, Op) { |op|
    if /Conjured/.match(op.item.name)
      op.quality *= 2
    end
    op
  }

  defn(:apply_op, Op) { |op|
    item = op.item
    unless op.quality.nil?
      item.quality += op.quality
    end
    unless op.sell_in.nil?
      item.sell_in += op.sell_in
    end
    item
  }
end


def update_quality(items)
  items.each do |item|
    case item.name
      when /Aged Brie/
        quality_clamp apply_op conjured brie regular item
      when /Backstage passes to TAFKAL80ETC concert/
        quality_clamp apply_op conjured backstage item
      when 'Sulfuras, Hand of Ragnaros'
        apply_op sulfuras item
      else
        quality_clamp apply_op conjured regular item
    end
  end
end