# This file was auto-generated from iller.yaml by Dist::Iller on 2021-06-30 18:16:28 UTC.

on runtime => sub {
    requires 'Carp' => '1.38';
    requires 'Module::Load' => '0.22';
    requires 'Moose' => '2.1400';
    requires 'MooseX::AttributeDocumented' => '0.1003';
    requires 'Path::Tiny' => '0.072';
    requires 'Pod::Elemental::Transformer' => '0';
    requires 'Stenciller' => '0.1302';
    requires 'Stenciller::Utils' => '0';
    requires 'Types::Path::Tiny' => '0.005';
    requires 'Types::Standard' => '1.000000';
    requires 'Types::Stenciller' => '0';
    requires 'namespace::autoclean' => '0.24';
    requires 'perl' => '5.014000';
};
on test => sub {
    requires 'ExtUtils::MakeMaker' => '0';
    requires 'File::Spec' => '0';
    requires 'IO::Handle' => '0';
    requires 'IPC::Open3' => '0';
    requires 'Pod::Elemental' => '0';
    requires 'Pod::Elemental::Transformer::Pod5' => '0';
    requires 'Test::Differences' => '0';
    requires 'Test::More' => '0.96';
};
on test => sub {
    recommends 'CPAN::Meta' => '2.120900';
};
on configure => sub {
    requires 'ExtUtils::MakeMaker' => '0';
};
on develop => sub {
    requires 'Badge::Depot' => '0.0103';
    requires 'Badge::Depot::Plugin::Coverage' => '0';
    requires 'Badge::Depot::Plugin::Githubactions' => '0';
    requires 'Badge::Depot::Plugin::Perl' => '0';
    requires 'Dist::Zilla' => '6.015';
    requires 'Dist::Zilla::Plugin::Author::CSSON::GithubActions::Workflow::TestWithMakefile' => '0.0106';
    requires 'Dist::Zilla::Plugin::Authority' => '1.009';
    requires 'Dist::Zilla::Plugin::BumpVersionAfterRelease::Transitional' => '0.009';
    requires 'Dist::Zilla::Plugin::ChangeStats::Dependencies::Git' => '0.0200';
    requires 'Dist::Zilla::Plugin::CheckChangesHasContent' => '0.011';
    requires 'Dist::Zilla::Plugin::Clean' => '0.07';
    requires 'Dist::Zilla::Plugin::ConfirmRelease' => '0';
    requires 'Dist::Zilla::Plugin::CopyFilesFromBuild' => '0.170880';
    requires 'Dist::Zilla::Plugin::DistIller::MetaGeneratedBy' => '0';
    requires 'Dist::Zilla::Plugin::ExecDir' => '0';
    requires 'Dist::Zilla::Plugin::Git' => '2.046';
    requires 'Dist::Zilla::Plugin::Git::Check' => '0';
    requires 'Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch' => '0.014';
    requires 'Dist::Zilla::Plugin::Git::Commit' => '0';
    requires 'Dist::Zilla::Plugin::Git::Contributors' => '0.035';
    requires 'Dist::Zilla::Plugin::Git::GatherDir' => '0';
    requires 'Dist::Zilla::Plugin::Git::Push' => '0';
    requires 'Dist::Zilla::Plugin::Git::Tag' => '0';
    requires 'Dist::Zilla::Plugin::GithubMeta' => '0.54';
    requires 'Dist::Zilla::Plugin::InstallRelease' => '0.008';
    requires 'Dist::Zilla::Plugin::License' => '0';
    requires 'Dist::Zilla::Plugin::MakeMaker' => '0';
    requires 'Dist::Zilla::Plugin::Manifest' => '0';
    requires 'Dist::Zilla::Plugin::ManifestSkip' => '0';
    requires 'Dist::Zilla::Plugin::MetaConfig' => '0';
    requires 'Dist::Zilla::Plugin::MetaJSON' => '0';
    requires 'Dist::Zilla::Plugin::MetaNoIndex' => '0';
    requires 'Dist::Zilla::Plugin::MetaProvides::Package' => '2.004003';
    requires 'Dist::Zilla::Plugin::MetaYAML' => '0';
    requires 'Dist::Zilla::Plugin::NextRelease::Grouped' => '0.0200';
    requires 'Dist::Zilla::Plugin::PodSyntaxTests' => '0';
    requires 'Dist::Zilla::Plugin::PodWeaver' => '4.006';
    requires 'Dist::Zilla::Plugin::Prereqs' => '0';
    requires 'Dist::Zilla::Plugin::PromptIfStale' => '0.057';
    requires 'Dist::Zilla::Plugin::Readme' => '0';
    requires 'Dist::Zilla::Plugin::ReadmeAnyFromPod' => '0.163250';
    requires 'Dist::Zilla::Plugin::RewriteVersion::Transitional' => '0.007';
    requires 'Dist::Zilla::Plugin::RunExtraTests' => '0.029';
    requires 'Dist::Zilla::Plugin::ShareDir' => '0';
    requires 'Dist::Zilla::Plugin::Test::Compile' => '2.058';
    requires 'Dist::Zilla::Plugin::Test::EOF' => '0.0501';
    requires 'Dist::Zilla::Plugin::Test::EOL' => '0.18';
    requires 'Dist::Zilla::Plugin::Test::NoTabs' => '0.15';
    requires 'Dist::Zilla::Plugin::Test::ReportPrereqs' => '0.027';
    requires 'Dist::Zilla::Plugin::Test::Version' => '1.09';
    requires 'Dist::Zilla::Plugin::TestRelease' => '0';
    requires 'Dist::Zilla::Plugin::UploadToCPAN' => '0';
    requires 'Pod::Elemental::Transformer::List' => '0';
    requires 'Pod::Elemental::Transformer::Splint' => '0.1201';
    requires 'Pod::Weaver::Plugin::SingleEncoding' => '0';
    requires 'Pod::Weaver::Plugin::Transformer' => '0';
    requires 'Pod::Weaver::PluginBundle::CorePrep' => '0';
    requires 'Pod::Weaver::Section::Authors' => '0';
    requires 'Pod::Weaver::Section::Badges' => '0.0401';
    requires 'Pod::Weaver::Section::Collect' => '0';
    requires 'Pod::Weaver::Section::GenerateSection' => '1.01';
    requires 'Pod::Weaver::Section::Generic' => '0';
    requires 'Pod::Weaver::Section::Leftovers' => '0';
    requires 'Pod::Weaver::Section::Legal' => '0';
    requires 'Pod::Weaver::Section::Name' => '0';
    requires 'Pod::Weaver::Section::Region' => '0';
    requires 'Pod::Weaver::Section::Version' => '0';
    requires 'Test::EOF' => '0';
    requires 'Test::EOL' => '0';
    requires 'Test::More' => '0.88';
    requires 'Test::NoTabs' => '1.4';
    requires 'Test::Pod' => '1.41';
    requires 'Test::Version' => '1';
    requires 'Test::Warnings' => '0.026';
};
on develop => sub {
    suggests 'Dist::Iller' => '0.1411';
    suggests 'Dist::Iller::Config::Author::CSSON' => '0.0328';
};
