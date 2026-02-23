#!/bin/bash
set -e

VERSION="${1:-3.0.0}"
REGISTRY="${2:-lvnacy}"
IMAGE_NAME="${3:-apparatus-plugin-foundry}"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔨 Building and pushing Docker images for ${IMAGE_NAME}:${VERSION}${NC}"

# Slim variant
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Slim variant (no pnpm store, no Playwright)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${REGISTRY}/${IMAGE_NAME}:slim-${VERSION} \
  -t ${REGISTRY}/${IMAGE_NAME}:slim-latest \
  --push \
  .

echo -e "${GREEN}✅ Slim variant pushed${NC}\n"

# Playwright-Storybook variant
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Playwright-Storybook variant (cached packages + Playwright)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg WITH_PNPM_STORE=true \
  --build-arg WITH_PLAYWRIGHT_BROWSERS=true \
  -t ${REGISTRY}/${IMAGE_NAME}:playwright-storybook-${VERSION} \
  -t ${REGISTRY}/${IMAGE_NAME}:playwright-storybook-latest \
  --push \
  .

echo -e "${GREEN}✅ Playwright-Storybook variant pushed${NC}\n"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Both images built and pushed!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Available at:"
echo -e "  ${BLUE}${REGISTRY}/${IMAGE_NAME}:slim-${VERSION}${NC}"
echo -e "  ${BLUE}${REGISTRY}/${IMAGE_NAME}:slim-latest${NC}"
echo -e "  ${BLUE}${REGISTRY}/${IMAGE_NAME}:playwright-storybook-${VERSION}${NC}"
echo -e "  ${BLUE}${REGISTRY}/${IMAGE_NAME}:playwright-storybook-latest${NC}"
