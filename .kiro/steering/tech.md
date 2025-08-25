# Technology Stack

## Architecture
- **Frontend**: React 19 with TypeScript
- **Backend**: Node.js with Express and TypeScript
- **Database**: Prisma ORM (database not yet configured)
- **Cloud**: AWS SDK v3 (Config Service integration)
- **AI**: OpenAI GPT-4o for remediation script generation

## Frontend Stack
- **Framework**: Create React App with TypeScript
- **UI Library**: Material-UI (MUI) v7 with Emotion styling
- **Charts**: Chart.js with react-chartjs-2
- **HTTP Client**: Axios
- **Testing**: Jest, React Testing Library

## Backend Stack
- **Runtime**: Node.js with TypeScript
- **Framework**: Express.js v5
- **Development**: ts-node-dev for hot reloading
- **AWS Integration**: @aws-sdk/client-config-service
- **AI Integration**: OpenAI SDK v4
- **Environment**: dotenv for configuration
- **CORS**: Enabled for frontend communication

## Development Commands

### Backend
```bash
cd backend
npm install
npm start          # Start development server with hot reload
npm test           # Run tests (not yet implemented)
```

### Frontend  
```bash
cd frontend
npm install
npm start          # Start React dev server (localhost:3000)
npm test           # Run Jest tests
npm run build      # Build for production
```

## Environment Configuration
Backend requires `.env` file with:
- `AWS_REGION` - AWS region (default: us-east-1)
- `OPENAI_API_KEY` - OpenAI API key for remediation generation

**AWS Authentication**: Use IAM roles, instance profiles, or AWS CLI configured credentials instead of hardcoded keys. The AWS SDK will automatically use the default credential chain.

## Terraform Guidelines

### Best Practices
- **Use Terraform MCP server** when needed to pull latest documentation and examples
- **Prefer `for_each` over `count`** for resource iteration and dynamic provisioning
- **Use Write only arguments** for secrets
- **Use modular approach** - organize Terraform code into reusable modules
- **Use official modules** for common resources:
  - VPC: Use `terraform-aws-modules/vpc/aws` 
  - ALB: Use `terraform-aws-modules/alb/aws`
- **VPC Configuration**: Ensure `map_public_ip_on_launch = true` for public subnets
- **Documentation**: Leverage terraform-mcp-server for up-to-date resource documentation

### Module Structure
```
terraform/
├── modules/           # Reusable modules
├── environments/      # Environment-specific configurations
└── main.tf           # Root configuration
```

## Development Setup
1. Configure AWS credentials using `aws configure` or IAM roles
2. Set OpenAI API key in backend/.env
3. Run Prisma migrations: `npx prisma migrate dev` (when database is configured)
4. Start backend: `cd backend && npm start` (port 4000)
5. Start frontend: `cd frontend && npm start` (port 3000)
6. Frontend proxies API calls to backend via proxy configuration