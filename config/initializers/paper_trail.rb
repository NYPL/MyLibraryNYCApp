# frozen_string_literal: true

#PaperTrail.config.track_associations = false


PaperTrail.config.enabled = true
PaperTrail.config.has_paper_trail_defaults = {
  on: [:create, :update, :destroy]
}
PaperTrail.config.version_limit = 3