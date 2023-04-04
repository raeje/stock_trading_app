class BatchStockQuoteJob
  include Sidekiq::Job

  SPACES_LENGTH = 10

  def perform
    start_time = Time.now
    p '------------------------------------------'
    p "  start: #{Time.now}"
    p '  First 500 stocks'

    nil_stock_counter = 0
    batch = Stock.quote_all(500)
    batch.each do |ticker|
      # p ['', ticker['symbol'], '', ticker['latestPrice']].join("\t")
      nil_stock_counter += 1 if ticker['latestPrice'].nil?
      gap = ' ' * (SPACES_LENGTH - ticker['symbol'].length)
      p "  #{ticker['symbol']}#{gap}#{ticker['latestPrice']}"
    end

    p "  Total nil stock: #{nil_stock_counter}"
    p "  Elapsed: #{Time.now - start_time}"
    p '------------------------------------------'
  end
end
