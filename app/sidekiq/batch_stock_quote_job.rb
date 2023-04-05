class BatchStockQuoteJob
  include Sidekiq::Job

  SPACES_LENGTH = 10
  BATCH_QUOTE_LIMIT = 10 # 600

  def perform
    start_time = Time.now
    p '------------------------------------------'
    p "  start: #{Time.now}"
    p "  First #{BATCH_QUOTE_LIMIT} stocks"

    quotes = iex_latest_price
    quotes.each do |stock|
      db_stock_id = Stock.find_id_by_ticker(stock['symbol'])
      orders = affected_orders(db_stock_id)
      orders.fulfill(stock['latestPrice'])

      gap = ' ' * (SPACES_LENGTH - stock['symbol'].length)
      p "  id: #{db_stock_id} orders: #{orders.length} #{stock['symbol']}#{gap}#{stock['latestPrice']}"
    end

    p "  Elapsed: #{Time.now - start_time}"
    p '------------------------------------------'
  end

  def affected_orders(stocks_id)
    Order.placed_buy.where(stocks_id:)
  end

  def iex_latest_price
    batch = Stock.quote_all(BATCH_QUOTE_LIMIT)
    batch.reject { |stock| stock['latestPrice'].nil? }
  end

  def print
    start_time = Time.now
    p '------------------------------------------'
    p "  start: #{Time.now}"
    p '  First 500 stocks'

    nil_stock_counter = 0
    batch = Stock.quote_all(600)
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
