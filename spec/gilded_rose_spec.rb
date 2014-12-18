require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 10 }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    it "your specs here" do
      item.sell_in.should == 4
      item.quality.should == 9
    end
  end

  context "sell by date passing" do
    let(:item) { Item.new("normal item", 0, 10) }

    before { update_quality([item]) }

    it "sell by date, 2x quality drop" do
      item.quality.should == 8
    end
  end

  context "conjured sell by date" do
    let(:item) { Item.new("Conjured Sword of Sell by Date", 0, 10) }

    before { update_quality([item]) }

    it "sell by date, 4x quality drop" do
      item.quality.should == 6
    end
  end


  context "sell by date passing, quality 0" do
    let(:item) { Item.new("normal item", 0, 0) }

    before { update_quality([item]) }

    it "sell by date, quality 0" do
      item.quality.should == 0
    end
  end


  context "Aged Brie" do
    let(:item) { Item.new("Aged Brie", 10, 10) }
    before { update_quality([item]) }

    it "default increment" do
      item.sell_in.should == 9
      item.quality.should == 11
    end
  end

  context "Conjured Aged Brie" do
    let(:item) { Item.new("Conjured Aged Brie", 10, 10) }
    before { update_quality([item]) }

    it "conjured default increment" do
      item.sell_in.should == 9
      item.quality.should == 12
    end
  end

  context "aged brie @ 50" do
    let(:item) { Item.new("Aged Brie", 10, 50) }
    before { update_quality([item]) }

    it "Aged Brie increment" do
      item.sell_in.should == 9
      item.quality.should == 50
    end
  end

  context "backstage passes" do
    let(:item) { Item.new("Backstage passes to TAFKAL80ETC concert", 12, 20) }

    before { update_quality([item]) }

    it "backstage passes" do
      item.quality.should == 21
      update_quality([item])
      item.quality.should == 22
      update_quality([item])
      item.sell_in.should == 9
      item.quality.should == 24

    end
  end

  context "backstage passes day 10" do
    let(:item) { Item.new("Backstage passes to TAFKAL80ETC concert", 10, 20) }

    before { update_quality([item]) }

    it "backstage passes" do
      item.sell_in.should == 9
      item.quality.should == 22
    end
  end

  context "conjured backstage passes day 10" do
    let(:item) { Item.new("Conjured Backstage passes to TAFKAL80ETC concert", 10, 20) }

    before { update_quality([item]) }

    it "backstage passes" do
      item.sell_in.should == 9
      item.quality.should == 24
    end
  end

  context "sulfuras" do
    let(:item) { Item.new('Sulfuras, Hand of Ragnaros',nil,80) }

    before { update_quality([item]) }

    it "sulfuras" do
      item.sell_in.should == nil
      item.quality.should == 80
    end
  end


  context "with multiple items" do
    let(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
      ]
    }

    before { update_quality(items) }

    it "your specs here" do
      items[0].sell_in.should == 4
      items[0].quality.should == 9
    end
  end
end
