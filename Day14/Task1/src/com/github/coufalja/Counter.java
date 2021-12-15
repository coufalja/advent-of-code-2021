package com.github.coufalja;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class Counter {
	final Map<String, Long> counts;

	public Counter() {
		this(new ConcurrentHashMap<>());
	}

	public Counter(Map<String, Long> counts) {
		this.counts = counts;
	}

	public Counter add(String t, long val) {
		counts.merge(t, val, Long::sum);
		return this;
	}

	public Counter add(Counter t) {
		var copy = new ConcurrentHashMap<>(this.counts);
		t.counts.forEach((s, i) -> copy.merge(s, i, Long::sum));
		return new Counter(copy);
	}

	public long mostCommon() {
		return counts.values().stream().max(Long::compareTo).orElse(0L);
	}

	public long leastCommon() {
		return counts.values().stream().min(Long::compareTo).orElse(0L);
	}

	@Override
	public String toString() {
		return counts.toString();
	}

}
