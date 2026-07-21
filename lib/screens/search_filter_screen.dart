import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../widgets/appzeto_animations.dart';
import '../widgets/animated_search_button.dart';

class SearchFilterScreen extends StatefulWidget {
  final VoidCallback onSearchTriggered;
  const SearchFilterScreen({super.key, required this.onSearchTriggered});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _searchController = TextEditingController();

  final List<String> _tags = [
    'Burger',
    'Vegetarian',
    'Healthy',
    'Indian',
    'Soup',
    'Fast food',
    'Salad',
    'Dessert',
    'Thai',
    'Breakfast',
    'Pizza',
    'Sushi',
    'Wings',
    'Bakery',
    'Coffee',
    'Asian',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmit(String query) {
    if (query.trim().isNotEmpty) {
      AppStateProvider.of(context, listen: false).updateSearchQuery(query.trim());
      widget.onSearchTriggered();
    }
  }

  void _onTagClick(String tag) {
    _searchController.text = tag;
    AppStateProvider.of(context, listen: false).updateSearchQuery(tag);
    widget.onSearchTriggered();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search input with AnimatedSearchButton
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          TextField(
                            controller: _searchController,
                            onSubmitted: _onSearchSubmit,
                            onChanged: (val) => setState(() {}),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, color: AppTheme.orange),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          state.updateSearchQuery('');
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                          if (_searchController.text.isEmpty)
                            const IgnorePointer(
                              child: Padding(
                                padding: EdgeInsets.only(left: 48),
                                child: AnimatedRotatingSearchPlaceholder(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedSearchButton(
                    onTap: () => _onSearchSubmit(_searchController.text),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Filter label or instructions
              const Text(
                'Recent / Popular Categories',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Tag cloud with BouncingTouchWrapper
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 12.0,
                    children: _tags.map((tag) {
                      return BouncingTouchWrapper(
                        onTap: () => _onTagClick(tag),
                        scaleFactor: 0.94,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.orange,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.orange.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
