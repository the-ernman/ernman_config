const settings = {
  name: "js",
  limit: 4,
  enabled: true,
  tags: ["alpha", "beta", "gamma"],
};

function summarize(input) {
  const count = input.tags.filter((tag) => tag.includes("a")).length;
  return `${input.name}:${count}:${input.enabled}`;
}

for (const [index, tag] of settings.tags.entries()) {
  const label = `${index}-${tag}`.toUpperCase();
  console.log(label, summarize(settings));
}
