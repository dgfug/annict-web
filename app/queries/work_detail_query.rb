# frozen_string_literal: true

class WorkDetailQuery < ApplicationQuery
  def initialize(work_id:)
    @work_id = work_id
  end

  def call
    build_object(execute(query_string))
  end

  private

  attr_reader :work_id

  def build_object(result)
    data = result.
      dig(:data, :works, :nodes).
      first

    attrs = data.slice(*WorkObject.attribute_names)
    attrs[:image] = WorkImageObject.new(data[:image])
    attrs[:trailers] = data.dig(:trailers, :nodes).map { |hash| TrailerObject.new(hash.slice(*TrailerObject.attribute_names)) }
    attrs[:casts] = data.dig(:casts, :nodes).map do |hash|
      CastObject.new(
        character: CharacterObject.new(hash[:character]),
        person: PersonObject.new(hash[:person]),
      )
    end
    attrs[:staffs] = data.dig(:staffs, :nodes).map do |hash|
      StaffObject.new(
        person: PersonObject.new(hash[:resource]),
        organization: nil,
        role_text: hash[:role_text]
      )
    end
    attrs[:episodes] = data.dig(:episodes, :nodes).map { |hash| EpisodeObject.new(hash.slice(*EpisodeObject.attribute_names)) }

    WorkObject.new(attrs)
  end

  def query_string
    <<~GRAPHQL
      {
        works(annictIds: [#{work_id}]) {
          nodes {
            id
            annictId
            title
            watchersCount
            satisfactionRate
            ratingsCount
            titleKana
            officialSiteUrl
            twitterUsername
            wikipediaUrl
            isNoEpisodes
            synopsis
            synopsisEn
            synopsisSource
            image {
              internalUrl(size: "280x")
            }
            copyright
            trailers(orderBy: { field: SORT_NUMBER, direction: ASC }) {
              nodes {
                title
                url
                internalImageUrl(size: "300x169")
              }
            }
            casts(orderBy: { field: SORT_NUMBER, direction: ASC }) {
              nodes {
                character {
                  annictId
                  name
                }
                person {
                  annictId
                  name
                }
              }
            }
            staffs(orderBy: { field: SORT_NUMBER, direction: ASC }) {
              nodes {
                resource {
                  ... on Person {
                    annictId
                    name
                  }
                  ... on Organization {
                    annictId
                    name
                  }
                }
                roleText
              }
            }
            episodes(orderBy: { field: SORT_NUMBER, direction: ASC }) {
              nodes {
                annictId
                numberText
                title
              }
            }
          }
        }
      }
    GRAPHQL
  end
end
