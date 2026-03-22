import path from "path";
import url from "url";

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));

/** @type {import("@eventcatalog/core/bin/eventcatalog.config").Config} */
export default {
  title: "MathTrail Event Catalog",
  tagline: "Event-driven architecture for MathTrail platform",
  organizationName: "MathTrail",
  homepageLink: "https://mathtrail.local",
  editUrl: "https://github.com/mathtrail/contracts/edit/main/eventcatalog",
  trailingSlash: false,
  primaryCTA: {
    label: "Explore Events",
    href: "/events",
  },
  generators: [
    [
      "@eventcatalog/generator-asyncapi",
      {
        services: [
          {
            path: path.join(__dirname, "../asyncapi/mathtrail-events.yaml"),
            id: "mathtrail-events",
          },
        ],
        domain: {
          id: "mathtrail",
          name: "MathTrail Platform",
          version: "0.1.0",
        },
      },
    ],
  ],
};
