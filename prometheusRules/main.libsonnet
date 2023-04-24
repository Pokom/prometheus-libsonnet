local crdsonnet = import 'github.com/Duologic/crdsonnet/crdsonnet/main.libsonnet';
local d = import 'github.com/jsonnet-libs/docsonnet/doc-util/main.libsonnet';

local render = 'dynamic';

local schema = import './schema.json';

local parsed = crdsonnet.fromSchema(
  'prometheusRules',
  schema,
  render=render
);

(
  if render == 'dynamic'
  then parsed.prometheusRules
  else parsed + '.prometheusRules'
)
+ (
  if render == 'dynamic'
  then import 'veneer.libsonnet'
  else importstr 'veneer.libsonnet'
)
+ (
  if render == 'dynamic'
  then
    {
      '#'::
        d.pkg(
          name='prometheusRules',
          url='github.com/crdsonnet/prometheus-libsonnet/prometheusRules',
          help=|||
            `prometheusRules` can generate recording rules and alerts for
            [prometheus](https://github.com/prometheus/prometheus).

            Additional information about the configuration options can be found in the
            [official](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/)
            [docs](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/).
          |||,
          filename=std.thisFile,
        ),

      // Exposed as non-plural version, easier to read
      groups: null,
      group:
        super.groups
        + {
          rules: null,  // Exposed one level higher for easier access

          '#new':: d.fn(
            |||
              `new` creates a new rule group.
            |||,
            args=[
              d.arg('name', d.T.string),
              d.arg('rules', d.T.array),
            ]
          ),
          new(name, rules):
            super.withName(name)
            + super.withRules(rules),
        },

      rule:
        super.groups.rules
        {
          '#newAlert':: d.fn(
            |||
              `newAlert` creates a new alert.
            |||,
            args=[
              d.arg('name', d.T.string),
              d.arg('expr', d.T.string),
            ]
          ),
          newAlert(name, expr)::
            super.withAlert(name)
            + super.withExpr(expr),

          '#newRule':: d.fn(
            |||
              `newRule` creates a new recording rule.
            |||,
            args=[
              d.arg('name', d.T.string),
              d.arg('expr', d.T.string),
            ]
          ),
          newRule(name, expr)::
            super.withRule(name)
            + super.withExpr(expr),
        },
    }
  else ''  // don't bother with docs for static rendering
)
