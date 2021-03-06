require 'pg'

class Peeps

  attr_reader :id, :content, :time

  def initialize(id:, content:, time:)
    @id  = id
    @content = content
    @time = time
  end

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_database_test')
    else
      connection = PG.connect(dbname: 'chitter_database')
    end
    result = connection.exec("SELECT * FROM peeps ORDER BY time DESC;")
    result.map do |peep|
     Peeps.new(id: peep['id'], content: peep['content'], time: peep['time'])
    end
  end

  def self.create(content:, time:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_database_test')
    else
      connection = PG.connect(dbname: 'chitter_database')
    end
    result = connection.exec("INSERT INTO peeps (content, time) VALUES('#{content}', '#{time}') RETURNING id, content, time")
    Peeps.new(id: result[0]['id'], content: result[0]['content'], time: result[0]['time'])
  end

end
