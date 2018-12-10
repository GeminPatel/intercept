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

    description[:decoration].each do |unit|
      decorator = Intercept::DecoratorBuilder.from_hash(unit[:decorator])

      unit[:fields].each do |field|
        decorator_map[field] = decorator
      end
    end

    Intercept::Worker.new(callback, interceptor_map, decorator_map)
  end
end
