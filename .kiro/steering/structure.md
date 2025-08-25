# Project Structure

## Root Directory Layout
```
├── backend/           # Node.js Express API server
├── frontend/          # React TypeScript application
├── .kiro/            # Kiro IDE configuration and steering
└── .vscode/          # VS Code workspace settings
```

## Backend Structure (`/backend`)
```
backend/
├── src/
│   ├── index.ts           # Express server entry point
│   ├── awsConfig.ts       # AWS Config Service client and utilities
│   ├── openai.ts          # OpenAI integration for remediation scripts
│   └── routes/            # Express route handlers
├── .env.example           # Environment variables template
├── package.json           # Dependencies and scripts
└── tsconfig.json          # TypeScript configuration
```

## Frontend Structure (`/frontend`)
```
frontend/
├── public/                # Static assets (favicon, manifest, etc.)
├── src/
│   ├── App.tsx           # Main application component with routing
│   ├── index.tsx         # React app entry point
│   ├── theme.ts          # Material-UI theme configuration
│   └── pages/            # Page components (Controls.tsx, etc.)
├── package.json          # Dependencies and scripts
└── tsconfig.json         # TypeScript configuration
```

## Key Architectural Patterns

### Backend Patterns
- **Service Layer**: Separate modules for AWS (`awsConfig.ts`) and OpenAI (`openai.ts`) integrations
- **Route Organization**: API routes organized under `/routes` directory
- **Environment Configuration**: Centralized in `.env` with dotenv
- **Error Handling**: Consistent error responses across API endpoints

### Frontend Patterns
- **Component Structure**: Pages in `/pages`, shared components in `/src`
- **State Management**: React hooks for local state, no global state library yet
- **API Integration**: Axios with proxy configuration to backend
- **UI Framework**: Material-UI with custom theme configuration
- **Routing**: Single-page application with conditional rendering based on page state

### Naming Conventions
- **Files**: camelCase for TypeScript files, PascalCase for React components
- **API Routes**: RESTful patterns (`/api/config/rules`, `/api/config/noncompliant/:ruleName`)
- **Components**: PascalCase React components with descriptive names
- **Variables**: camelCase for JavaScript/TypeScript variables

### Data Flow
1. Frontend makes API calls to backend via Axios
2. Backend fetches data from AWS Config Service
3. OpenAI integration generates remediation scripts on demand
4. Frontend displays compliance data using Material-UI components
5. Real-time dashboard updates via API polling (no WebSocket yet)