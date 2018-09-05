#ifndef TM_DELAY_INCLUDED
#define TM_DELAY_INCLUDED

template <typename T, int n_samples>
class TM_delay {
  public:
    TM_delay();
    T operator()(T sample);
  private:
    T ring[n_samples];
    int next;
    bool filled;
};

template <typename T, int n_samples>
TM_delay<T,n_samples>::TM_delay() {
  next = 0;
  filled = false;
}

template <typename T, int n_samples>
T TM_delay<T,n_samples>::operator()(T sample) {
  if (!filled) {
    for (next = 0; next < n_samples; ++next) {
      ring[next] = sample;
    }
    next = 0;
    filled = true;
  }
  T rv = ring[next];
  ring[next] = sample;
  if (++next == n_samples)
    next = 0;
  return rv;
}
#endif
