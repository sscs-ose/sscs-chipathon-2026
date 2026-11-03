# Registering for IEEE SSCS 2026 Chipathon

A step-by-step guide to ensure that your team and all members are registered for the 2026 chipathon.

1. Join the 2026 SSCS "PICO" Open-Source Chipathon discord server. https://discord.gg/bAQFg6UAsU <br>The #chipathon-announcements channel will have important information. Check it daily.
   
3. Edit Per-server Profile and set Server Nickname. Use only English letters.
<img width="320" height="616" alt="スクリーンショット 2026-06-11 0 19 49" src="https://github.com/user-attachments/assets/f705f0f2-3297-4ea5-9004-03a32358d498" />


<img width="697" height="378" alt="スクリーンショット 2026-06-11 0 22 44" src="https://github.com/user-attachments/assets/202d6b23-2f75-4e1f-a7a4-07eb12928f31" />


3. Complete the one time registration using [this google form](https://forms.gle/oX4Bes1dQkHNz4N27).
4. Fork the repo for project development.
   - The team lead should login to github.com
   - Goto https://github.com/Mauricio-xx/chipathon-2026-gf180mcu-padring and create a fork.
     <img width="1294" height="235" alt="スクリーンショット 2026-06-11 10 44 04" src="https://github.com/user-attachments/assets/c0c51fa7-8907-46a4-9634-e5c0b16064d1" />
     <img width="1150" height="615" alt="スクリーンショット 2026-06-11 10 44 28" src="https://github.com/user-attachments/assets/18633531-0a79-4b56-b84a-fc415267136c" />
   - Team members should fork the team lead's repo.
5. Setup your local development repo. <br>Copy your forked repo's url as in this screen shot.
   <img width="1346" height="427" alt="スクリーンショット 2026-06-11 10 48 42" src="https://github.com/user-attachments/assets/b7234eac-e906-4154-abad-4d6e77c85034" />
   ```
   git clone <your-project-url>
   cd <your-project-directory>
   git remote add upstream <url-of-the-base-repo-you-forked>
   git remote -v
   ```
This should display something like this, with the upstream remote pointing to the base of your fork.
```
% git remote -v
origin	https://github.com/d-m-bailey/chipathon2026-project.git (fetch)
origin	https://github.com/d-m-bailey/chipathon2026-project.git (push)
upstream	https://github.com/Mauricio-xx/chipathon-2026-gf180mcu-padring.git (fetch)
upstream	https://github.com/Mauricio-xx/chipathon-2026-gf180mcu-padring.git (push)
```
6. The team lead should create an issue for their project at https://github.com/sscs-ose/sscs-chipathon-2026/issues based on [this sample](https://github.com/sscs-ose/sscs-chipathon-2026/issues/123). Initial issues should be brief (viewable with scrolling) with links to detailed explanations. The team lead will be responsible for updating the first comment of the issue. The initial issue title should be of the format `[Track X] team-name: project title` where `X` is `A`, `B`, `C`, or `D`.
7. Create your proposal. There is a bare bones [sample](https://github.com/sscs-ose/sscs-chipathon-2026/blob/main/resources/documents/template_2026_ChipathonProposals.pptx) that you can start from. You can use powerpoint or Google slides or something else. Add a link to your proposal in the first comment of your issue.
8. Once I've verified that your team has created a github issue with a link to your team lead's repo and the proposal, I'll assign you a team code like `B23`. I will modify your issue title to include the team code like `[Team B23 SampleTeam] Project title`. I will also add your team to the weekly form and create an entry in the proposal presentation.
9. Once you have a team code, you should add abbreviated proposal slides (max 2 minutes) to the appropriate file in [this folder](https://drive.google.com/drive/folders/17JDAons__77M-8cUutcNxy6rYa_PkrL9?usp=sharing). If you will not be able to present your proposal during the meeting include a video instead. Each file has a sample abbreviated proposal at the beginning.
10. Add the [info.yaml](https://github.com/sscs-ose/sscs-chipathon-2026/blob/main/resources/info.yaml) file to the top directory of your repo. This file will define your project's status (`def_ready`, `drc_ready`, `lvs_ready`), the location and name of the [lvs_config.json](https://github.com/sscs-ose/sscs-chipathon-2026/blob/main/resources/lvs_config.json) file and the [export_control document](https://github.com/sscs-ose/sscs-chipathon-2026/blob/main/resources/documents/Export_Control_GF_Rev8.2.docx) along with the padring pad names and types.
