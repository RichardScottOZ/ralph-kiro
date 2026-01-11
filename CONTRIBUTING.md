# Contributing to Ralph Wiggum for Kiro CLI

First off, thank you for considering contributing to this project! 🎉

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the problem
- Expected vs actual behavior
- Your environment (OS, Kiro CLI version, etc.)
- Relevant logs or error messages

### Suggesting Enhancements

Have an idea to improve the workflow? Open an issue with:
- A clear description of the enhancement
- Why it would be useful
- How it should work
- Examples if applicable

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/RichardScottOZ/ralph-kiro.git
   cd ralph-kiro
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Keep changes focused and atomic
   - Follow existing code style
   - Update documentation as needed
   - Test your changes

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: your feature description"
   ```

4. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then open a Pull Request on GitHub

## Development Guidelines

### Code Style

- **Shell Scripts**: Follow Google Shell Style Guide
  - Use meaningful variable names
  - Add comments for complex logic
  - Include error handling

- **YAML Files**: 
  - Use 2-space indentation
  - Keep keys lowercase with underscores
  - Add comments for non-obvious settings

- **Markdown**:
  - Use clear headings and structure
  - Include code examples
  - Keep lines under 120 characters when possible

### Agent Configurations

When modifying `.kiro/agents/*.yaml`:
- Test with real Kiro CLI
- Ensure instructions are clear and specific
- Add examples in comments
- Consider different user skill levels

### Templates

When updating templates:
- Keep them generic and adaptable
- Include helpful comments
- Provide examples of good vs bad usage
- Test with various project types

### Scripts

When modifying shell scripts:
- Test on both Linux and macOS
- Handle errors gracefully
- Provide helpful error messages
- Include usage examples with `--help`

## Testing

Before submitting a PR:

1. **Test the setup script**
   ```bash
   ./setup-ralph.sh test-project
   cd test-project
   # Verify all files are created correctly
   ```

2. **Test the execution script**
   ```bash
   ./ralph-execute.sh --help
   # Verify help output is correct
   ```

3. **Test with a real project**
   - Run through all three phases
   - Document any issues
   - Ensure examples work

## Documentation

- Update README.md for major changes
- Update QUICKSTART.md for workflow changes
- Add examples for new features
- Keep documentation clear and beginner-friendly

## Areas We Need Help With

- 🧪 **Testing**: Testing on different platforms and configurations
- 📚 **Documentation**: Improving clarity and adding examples
- 🎨 **Examples**: More real-world project examples
- 🔧 **Features**: New agent configurations or workflow improvements
- 🐛 **Bug Fixes**: Fixing reported issues
- 🌍 **Translations**: Translating documentation

## Questions?

Feel free to open an issue with your question or reach out to maintainers.

## Code of Conduct

Be respectful, inclusive, and constructive. We're all here to learn and improve.

---

## Attribution

This project is based on:
- **Ralph Wiggum Workflow** by Geoffrey Huntley
- **Original Gist** by Mburdo
- Adapted for **Kiro CLI**

When contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🚀
