class BatchStockQuoteJob
  include Sidekiq::Job
  # Sidekiq.redis(&:flushdb)

  queued_jobs = Sidekiq.redis { |conn| conn.keys('*') }
  p '--------------------------------------------------------------'
  p queued_jobs
  p queued_jobs.count('batch_stock_quote_job')
  p '--------------------------------------------------------------'

  p '--------------------------------------------------------------'
  job_count = queued_jobs.select { |job| job.match(/batch_stock_quote_job/) }
  if job_count.length.positive?
    p 'batch_stock_quote_job is already running..'
    exit 0
  else
    p 'no queued job..'
  end
  p '--------------------------------------------------------------'

  SPACES_LENGTH = 10
  BATCH_QUOTE_LIMIT = 1100 # 999

  def perform
    start_time = print_start
    p "  First #{BATCH_QUOTE_LIMIT} stocks"

    print_headers
    offset_count = 0
    while offset_count < Stock.count
      quotes = iex_latest_price(offset_count)
      execute_orders(quotes)
      offset_count += BATCH_QUOTE_LIMIT
    end

    print_elapsed(start_time)
  end

  def affected_orders(stocks_id)
    Order.placed_buy.where(stocks_id:)
  end

  def execute_orders(stocks)
    counter = 0
    stocks.each do |stock|
      counter += 1
      stocks_id = Stock.find_id_by_ticker(stock['symbol'])
      price = stock['latestPrice']

      buy_orders, sell_orders = fulfill_orders(stocks_id, price)

      if (BATCH_QUOTE_LIMIT - 30) <= counter
        print_row([stocks_id, stock['symbol'], buy_orders.length, sell_orders.length, stock['latestPrice']])
      end
    end
  end

  def fulfill_orders(stocks_id, price)
    buy_orders = Order.placed_buy.where(stocks_id:)
    buy_orders.fulfill(price)

    sell_orders = Order.placed_sell.where(stocks_id:)
    sell_orders.fulfill(price)

    [buy_orders, sell_orders]
  end

  def iex_latest_price(offset_count)
    # batch = Stock.quote_all(BATCH_QUOTE_LIMIT)
    batch = Stock.batch_quote(BATCH_QUOTE_LIMIT, offset_count)
    batch.reject { |stock| stock['latestPrice'].nil? }
  end

  def print_start
    p '------------------------------------------'
    p "  start: #{Time.now}"
    Time.now
  end

  def print_elapsed(start_time)
    p "  Elapsed: #{Time.now - start_time}"
    p '------------------------------------------'
  end

  def print_headers
    p '               STOCKS               |     ORDERS     |'
    p '  id    |  symbol  |  latest_price  |  buy  |  sell  |'
  end

  def print_row(arr)
    p '  ' + arr[0].to_s.ljust(4) + '  |  ' + arr[1].ljust(6) + '  |  ' +
             arr[4].to_s.rjust(12) + '  |  ' + arr[2].to_s.rjust(3) + '  |  ' +
             arr[3].to_s.rjust(4) + '  |'
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
