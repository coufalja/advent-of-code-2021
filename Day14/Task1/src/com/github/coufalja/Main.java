package com.github.coufalja;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;

public class Main {

	public static void main(String[] args) throws Exception {
		var content = Files.readString(Path.of("..", "input.txt"));
		var split = content.split(System.lineSeparator() + System.lineSeparator());
		var polymer = split[0];
		var rules = RuleBook.parse(split[1]);

		var result = iterate(polymer, rules, 10);

		System.out.println("Result: " + (result.mostCommon() - result.leastCommon()));
	}

	private static Counter iterate(String polymer, RuleBook rules, int iterations) {
		var counters = rules.counters();
		for (int i = 0; i < iterations; i++) {
			var newCounters = new HashMap<String, Counter>();

			for (var rule : rules.entries()) {
				var sum = counters.get(rule.getLeft()).add(counters.get(rule.getRight()));
				// Remove double count of a middle letter
				sum = sum.add(rule.getInsert(), -1);

				newCounters.put(rule.getPattern(), sum);
			}
			counters = newCounters;
		}

		// Recalculate using a seed
		var resultCounter = new Counter();
		for (int i = 0; i < polymer.length() - 1; i++) {
			resultCounter = resultCounter.add(counters.get(polymer.substring(i, i + 2)));
		}
		// Remove double count of middle part of a seed
		for (var s : polymer.substring(1, polymer.length() - 1).split("")) {
			resultCounter = resultCounter.add(s, -1);
		}
		return resultCounter;
	}

}
