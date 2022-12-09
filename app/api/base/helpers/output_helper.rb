module Base::Helpers::OutputHelper
  def local_time(time)
    time&.strftime('%Y-%m-%d %H:%M:%S')
  end

  def strip_trailing_zero(n, size = 4)
    n.to_f.round(size.to_i).to_s.sub(/\.?0+$/, '')
  end
end
