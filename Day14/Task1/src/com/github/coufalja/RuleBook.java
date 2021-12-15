package com.github.coufalja;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public class RuleBook {
	private final List<Rule> rules;

	private RuleBook(List<Rule> rules) {
		this.rules = rules;
	}

	public static RuleBook parse(String rules) {
		var parsed = Arrays.stream(rules.split(System.lineSeparator()))
				.map(s -> s.split(" -> "))
				.map(s -> Map.of(s[0], s[1]))
				.map(Map::entrySet)
				.flatMap(Collection::stream)
				.collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
		var rs = parsed.entrySet()
				.stream()
				.map(Rule::new)
				.collect(Collectors.toList());
		return new RuleBook(rs);
	}

	public List<Rule> entries() {
		return rules;
	}

	private static Counter initCounter(Rule s) {
		Counter counter = new Counter();
		return counter
				.add(String.valueOf(s.getPattern().charAt(0)), 1)
				.add(String.valueOf(s.getPattern().charAt(1)), 1);
	}

	public Map<String, Counter> counters() {
		return rules.stream()
				.collect(Collectors.toMap(Rule::getPattern, RuleBook::initCounter));
	}

	public static class Rule {
		private final Map.Entry<String, String> entry;
		private final String left;
		private final String right;

		public Rule(Map.Entry<String, String> entry) {
			this.entry = entry;
			this.left = entry.getKey().split("")[0] + entry.getValue();
			this.right = entry.getValue() + entry.getKey().split("")[1];
		}

		public String getPattern() {
			return entry.getKey();
		}

		public String getInsert() {
			return entry.getValue();
		}

		public String getLeft() {
			return left;
		}

		public String getRight() {
			return right;
		}

		@Override
		public String toString() {
			return "Rule{" +
					"entry=" + entry +
					", left='" + left + '\'' +
					", right='" + right + '\'' +
					'}';
		}

	}

}
