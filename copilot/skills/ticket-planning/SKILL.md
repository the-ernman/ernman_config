---
name: ticket-planning
description: Ticket planning practices for effective project management. Activate for project management files, planning documents, and ticketing systems.
---
# Ticket Planning

## Understand the Work

- Effective planning requires clear communication, well-defined tasks, and a structured approach to managing work.
- If you are missing context or feel that you do not have a proper view of the work request additional information from the user, do not make assumptions

## Sizing Guide

1. Epics - Large features or initiatives that can be broken down into multiple stories or tasks.
2. Stories - User-centric features or functionalities that deliver value to the end-user.
3. Tasks - Specific, actionable items that contribute to the completion of a story or epic.
4. Subtasks - Smaller, detailed steps that make up a task, often assigned to individual team members.

## Epic/Story/Task/Subtask Template

```markdown
---
name: <epic/story/task/subtask name>
parent: <parent epic/story/task or null>
type: <epic/story/task/subtask>
description: <brief description of the epic/story/task/subtask>
tshirt_size: <S/M/L/XL>
estimation: <estimated days to complete>
---

**Background**
1. XXX

**Story**
As a <team> member, I want XXX so that XXX

**Acceptance Criteria**
1. XXX

**Cautions**
1. XXX if needed

**Out-of-Scope**
1. XXX if needed
```

## Ticket Planning Rules

- Use the Epic/Story/Task/Subtask template for all tickets.
- Ensure that each ticket has clear acceptance criteria and is actionable.
- Avoid vague descriptions; provide sufficient context and background.
- Break down large tasks into smaller, manageable subtasks.
- Prioritize tickets based on business value and urgency.

## Sizing Rules

- Use T-shirt sizing (S, M, L, XL) for initial estimates.
- Provide rationale for sizing decisions in the ticket description.
- Reassess sizing as more information becomes available or as the project evolves.

## Output

- Ensure that you use the template for all tickets.
- All tickets should be saved to a `.md` file in the `tickets/` directory unless otherwise specified.
