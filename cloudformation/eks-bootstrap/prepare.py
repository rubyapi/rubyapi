"""Render the reviewed bootstrap additions onto the exact deployed core snapshot."""

from copy import deepcopy
from hashlib import sha256
import json
from pathlib import Path

from cfnlint.decode import cfn_yaml

HERE = Path(__file__).resolve().parent


def main():
    baseline_bytes = (HERE / "core-before.json").read_bytes()
    if sha256(baseline_bytes).hexdigest() != "0d2615a0c460fce93ef2c98c0469956bcaceeec1a2c47eeb31a45cc18f640a0c":
        raise ValueError("The reviewed 51-resource baseline changed; refresh and review explicitly")
    baseline = json.loads(baseline_bytes)
    additions = cfn_yaml.loads((HERE / "additions.yaml").read_text())
    result = deepcopy(baseline)
    for section, entries in additions.items():
        if result.get(section, {}).keys() & entries.keys():
            raise ValueError(f"Bootstrap must not overwrite existing {section}")
        result.setdefault(section, {}).update(entries)
    result["Description"] = "RubyAPI existing core with one private bootstrap/release executor and custom node IAM."
    # Keep the full template below CloudFormation's inline 51,200-byte limit.
    # The additions and frozen baseline remain separately readable for review.
    encoded = (json.dumps(result, separators=(",", ":")) + "\n").encode()
    if len(encoded) > 51_200:
        raise ValueError("Template exceeds CloudFormation's inline limit")
    (HERE / "core.template.json").write_bytes(encoded)
    summary = {
        "stack": "rubyapi-prod-edge",
        "baseline_sha256": sha256(baseline_bytes).hexdigest(),
        "template_sha256": sha256(encoded).hexdigest(),
        "resources_before": len(baseline["Resources"]),
        "resources_after": len(result["Resources"]),
        "additions": {k: v["Type"] for k, v in additions["Resources"].items()},
        "existing_resource_changes": [],
        "human_access": False,
        "production_sql_or_cutover": False,
    }
    (HERE / "review.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
