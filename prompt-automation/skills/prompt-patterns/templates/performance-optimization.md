# Performance Optimization Template

```markdown
# Task: Optimize {{component_name}}

## Baseline Metrics
Current performance:
- {{metric_1}}: {{baseline_1}}
- {{metric_2}}: {{baseline_2}}

## Target Metrics
Target performance:
- {{metric_1}}: {{target_1}}
- {{metric_2}}: {{target_2}}

Improvement: {{improvement_percentage}}%

## Profiling Strategy
1. {{profiling_step_1}}
2. {{profiling_step_2}}
3. Identify bottlenecks

## Optimization Tasks
1. Profile to identify bottlenecks
2. Implement optimization {{opt_1}}
3. Benchmark improvement
4. Implement optimization {{opt_2}}
5. Benchmark again
6. Verify no regressions

## Acceptance Criteria
- [ ] Target metrics achieved
- [ ] All tests still passing
- [ ] No functionality broken
- [ ] Benchmarks documented

## Validation
```bash
{{test_command}}
{{benchmark_command}}
```

Output: <promise>OPTIMIZED</promise>
```
