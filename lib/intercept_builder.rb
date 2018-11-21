class InterceptBuilder
  def self.build_worker(callback, description)
    interceptor_map = {}
    decorator_map = {}

    description[:interception].each do |unit|
      strategy = Intercept::StrategyBuilder.from_hash(unit[:strategy])

      unit[:fields].each do |field|
        interceptor_map[field] = strategy
      end
    end

    Intercept::Worker.new(callback, interceptor_map, decorator_map)
  end
end
