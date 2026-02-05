# Managing Context

## Let Agent Find Context

You don't need to manually tag every file in your prompt.

- Modern agents have powerful search tools and pull context on demand
- When you ask about "the authentication flow," agent finds relevant files through grep and semantic search
- Keep it simple: if you know the exact file, tag it. If not, agent will find it
- Including irrelevant files can confuse agent about what's important

## Helpful Tools

- `@Branch` - Give agent context about what you're working on
- "Review the changes on this branch" or "What am I working on?" orient agent to current task

## When to Start New Conversation

**Start a new conversation when:**
- You're moving to a different task or feature
- Agent seems confused or keeps making the same mistakes
- You've finished one logical unit of work

**Continue the conversation when:**
- You're iterating on the same feature
- Agent needs context from earlier in the discussion
- You're debugging something it just built

## Long Conversations

Long conversations can cause agent to lose focus. After many turns and summarizations:
- Context accumulates noise
- Agent can get distracted or switch to unrelated tasks
- If effectiveness decreases, start a new conversation

## Reference Past Work

When starting a new conversation, use `@Past Chats` to reference previous work rather than copy-pasting the whole conversation. Agent can selectively read from chat history to pull in only needed context.

This is more efficient than duplicating entire conversations.
